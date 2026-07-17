require "bundler"
require "yaml"

ENV["RACK_ENV"] ||= "development"
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

if defined?(Dotenv)
  Dotenv.load
end

require "sinatra/activerecord"

# The bakery's week and bread day are local dates, so pin the application to
# the bakery's zone rather than the server's clock (which is UTC in production).
Time.zone = ENV.fetch("TIME_ZONE", "Australia/Melbourne")
ActiveRecord::Base.time_zone_aware_attributes = true

require_relative "models/announcement"
require_relative "models/bread_day"
require_relative "models/post"
require_relative "models/order"
require_relative "models/order_item"
require_relative "models/order_notification"
require_relative "models/weekly_selection"

DEV_SESSION_SECRET =
  "a-development-session-secret-that-is-long-enough-0000000000000000"

configure do
  set :haml, format: :html5
  set :session_secret, ENV.fetch("SESSION_SECRET", DEV_SESSION_SECRET)
  enable :sessions
end

# Guard the forms with CSRF tokens everywhere except the test suite, which
# follows the convention of disabling forgery protection for request specs.
configure :production, :development do
  use Rack::Protection::AuthenticityToken
end

configure :production do
  Mail.defaults do
    delivery_method :smtp,
      address: ENV["SMTP_ADDRESS"],
      port: ENV.fetch("SMTP_PORT", 587),
      user_name: ENV["SMTP_USERNAME"],
      password: ENV["SMTP_PASSWORD"],
      authentication: :plain,
      enable_starttls_auto: true
  end
end

configure :development do
  Mail.defaults { delivery_method :logger }
end

# Rate limiting to blunt spam orders and admin password guessing.
ORDER_RATE_LIMIT = 5
ORDER_RATE_PERIOD = 60
LOGIN_RATE_LIMIT = 10
LOGIN_RATE_PERIOD = 300

Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

Rack::Attack.throttle(
  "orders/ip",
  limit: ORDER_RATE_LIMIT,
  period: ORDER_RATE_PERIOD
) do |request|
  if request.post? && request.path == "/bread/orders"
    request.ip
  end
end

Rack::Attack.throttle(
  "admin-login/ip",
  limit: LOGIN_RATE_LIMIT,
  period: LOGIN_RATE_PERIOD
) do |request|
  if request.post? && request.path == "/bread/admin/session"
    request.ip
  end
end

use Rack::Attack

configure :test do
  Mail.defaults { delivery_method :test }
  Rack::Attack.enabled = false
end

TALKS = YAML.load_file("data/talks.yml").freeze
TESTIMONIALS = YAML.load_file("data/testimonials.yml").freeze
BREADS = YAML.load_file("data/breads.yml").freeze
# Fallback when the admin hasn't chosen this week's breads yet.
WEEKLY_BREAD_IDS = BREADS.first(3).map { |bread| bread["id"] }.freeze

helpers do
  def admin?
    session[:admin] == true
  end

  def announcement
    Announcement.current
  end

  def bread_day_heading
    BreadDay.for_week_of(Date.current).heading
  end

  def correct_password?(password)
    expected = ENV["ADMIN_PASSWORD"].to_s

    !expected.empty? && Rack::Utils.secure_compare(expected, password.to_s)
  end

  def csrf_token
    Rack::Protection::AuthenticityToken.token(session)
  end

  def honeypot_filled?
    !params[:email].to_s.strip.empty?
  end

  def money(amount)
    format("$%.2f", amount)
  end

  def require_admin!
    unless admin?
      redirect "/bread/admin/login"
    end
  end

  def order_error(order, items)
    if items.empty?
      "Please choose at least one loaf."
    else
      order.errors.full_messages.to_sentence
    end
  end

  def ordered_items(breads, quantities)
    quantities ||= {}

    breads.filter_map do |bread|
      quantity = quantities[bread["id"]].to_i

      if quantity.positive?
        {
          id: bread["id"],
          name: bread["name"],
          price: bread["price"],
          quantity: quantity,
        }
      end
    end
  end

  def weekly_breads
    ids = WeeklySelection.current_bread_ids.presence || WEEKLY_BREAD_IDS

    BREADS.select { |bread| ids.include?(bread["id"]) }
  end
end

get "/application.css" do
  scss :"stylesheets/application"
end

get "/" do
  @active = :home
  haml :index, locals: { talks: TALKS, testimonials: TESTIMONIALS }
end

get "/articles" do
  @active = :articles
  @title = "Articles"
  haml :articles, locals: { posts: Post.all }
end

get "/articles/:slug" do
  post = Post.find(params[:slug])

  if post
    @active = :articles
    @title = post.title
    haml :article, locals: { post: post }
  else
    status 404
    haml :not_found
  end
end

get "/bread" do
  @title = "Elle Bread"
  haml :bread, locals: {
    breads: weekly_breads,
    error: nil,
    name: nil,
    order: nil,
    phone: nil,
    quantities: {},
  }
end

post "/bread/orders" do
  @title = "Elle Bread"
  breads = weekly_breads
  items = ordered_items(breads, params[:items])
  order = Order.build(
    items: items,
    name: params[:name],
    phone: params[:phone]
  )

  if honeypot_filled?
    haml :bread, locals: {
      breads: breads,
      error: nil,
      name: nil,
      order: order,
      phone: nil,
      quantities: {},
    }
  elsif items.any? && order.save
    begin
      OrderNotification.deliver(order)
    rescue StandardError => error
      warn "Order notification failed for order #{order.id}: #{error.message}"
    end

    haml :bread, locals: {
      breads: breads,
      error: nil,
      name: nil,
      order: order,
      phone: nil,
      quantities: {},
    }
  else
    status 422
    haml :bread, locals: {
      breads: breads,
      error: order_error(order, items),
      name: params[:name],
      order: nil,
      phone: params[:phone],
      quantities: params[:items] || {},
    }
  end
end

get "/bread/admin/login" do
  @title = "Admin"

  if admin?
    redirect "/bread/admin"
  else
    haml :admin_login, locals: { error: nil }
  end
end

post "/bread/admin/session" do
  if correct_password?(params[:password])
    session[:admin] = true
    redirect "/bread/admin"
  else
    @title = "Admin"
    status 401
    haml :admin_login, locals: { error: "Incorrect password." }
  end
end

delete "/bread/admin/session" do
  session.delete(:admin)
  redirect "/bread"
end

get "/bread/admin" do
  require_admin!
  @title = "Admin"
  haml :admin, locals: {
    breads: BREADS,
    orders: Order.recent.includes(:order_items),
    selected_ids: WeeklySelection.current_bread_ids,
  }
end

put "/bread/admin/announcement" do
  require_admin!
  Announcement.set(params[:message])
  redirect "/bread/admin"
end

put "/bread/admin/weekly-selection" do
  require_admin!
  catalog_ids = BREADS.map { |bread| bread["id"] }
  chosen = Array(params[:bread_ids]).select { |id| catalog_ids.include?(id) }
  WeeklySelection.replace(chosen)
  redirect "/bread/admin"
end
