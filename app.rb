require "bundler"
require "yaml"
Bundler.require(:default)
require_relative "post"

configure do
  set :haml, format: :html5
end

TALKS = YAML.load_file("data/talks.yml").freeze
TESTIMONIALS = YAML.load_file("data/testimonials.yml").freeze
BREADS = YAML.load_file("data/breads.yml").freeze
# Placeholder until the admin can persist a weekly selection.
WEEKLY_BREAD_IDS = BREADS.first(3).map { |bread| bread["id"] }.freeze

helpers do
  def money(amount)
    format("$%.2f", amount)
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
    BREADS.select { |bread| WEEKLY_BREAD_IDS.include?(bread["id"]) }
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
    total = items.sum { |item| item[:quantity] * item[:price] }
    order = { items: items, name: name, phone: phone, total: total }
    # TODO: persist the order and email a notification (pending backend choice).
    haml :elle_bread, locals: { breads: breads, error: nil, order: order }
  else
    status 422
    error = "Please choose at least one loaf and enter your name and phone."
    haml :elle_bread, locals: { breads: breads, error: error, order: nil }
  end
end
