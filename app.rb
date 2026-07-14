require "bundler"
require "yaml"

ENV["RACK_ENV"] ||= "development"
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

if defined?(Dotenv)
  Dotenv.load
end

require "sinatra/activerecord"
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

configure :test do
  Mail.defaults { delivery_method :test }
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

  def correct_password?(password)
    expected = ENV["ADMIN_PASSWORD"].to_s

    !expected.empty? && Rack::Utils.secure_compare(expected, password.to_s)
  end

  def money(amount)
    format("$%.2f", amount)
  end

  def require_admin!
    unless admin?
      redirect "/elle-bread/admin/login"
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

get "/elle-bread" do
  @active = :elle_bread
  @title = "Elle Bread"
  haml :elle_bread, locals: { breads: weekly_breads, error: nil, order: nil }
end

post "/elle-bread/orders" do
  @active = :elle_bread
  @title = "Elle Bread"
  breads = weekly_breads
  items = ordered_items(breads, params[:items])
  name = params[:name].to_s.strip
  phone = params[:phone].to_s.strip

  if items.any? && !name.empty? && !phone.empty?
    order = Order.place(items: items, name: name, phone: phone)

    begin
      OrderNotification.deliver(order)
    rescue StandardError => error
      warn "Order notification failed for order #{order.id}: #{error.message}"
    end

    haml :elle_bread, locals: { breads: breads, error: nil, order: order }
  else
    status 422
    error = "Please choose at least one loaf and enter your name and phone."
    haml :elle_bread, locals: { breads: breads, error: error, order: nil }
  end
end

get "/elle-bread/admin/login" do
  @active = :elle_bread
  @title = "Admin"

  if admin?
    redirect "/elle-bread/admin"
  else
    haml :admin_login, locals: { error: nil }
  end
end

post "/elle-bread/admin/session" do
  if correct_password?(params[:password])
    session[:admin] = true
    redirect "/elle-bread/admin"
  else
    @active = :elle_bread
    @title = "Admin"
    status 401
    haml :admin_login, locals: { error: "Incorrect password." }
  end
end

delete "/elle-bread/admin/session" do
  session.delete(:admin)
  redirect "/elle-bread"
end

get "/elle-bread/admin" do
  require_admin!
  @active = :elle_bread
  @title = "Admin"
  haml :admin, locals: {
    breads: BREADS,
    orders: Order.recent.includes(:order_items),
    selected_ids: WeeklySelection.current_bread_ids,
  }
end

put "/elle-bread/admin/weekly-selection" do
  require_admin!
  catalog_ids = BREADS.map { |bread| bread["id"] }
  chosen = Array(params[:bread_ids]).select { |id| catalog_ids.include?(id) }
  WeeklySelection.replace(chosen)
  redirect "/elle-bread/admin"
end
