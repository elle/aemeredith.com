require_relative "config/environment"
require_relative "helpers"

helpers ApplicationHelpers

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
    halt 404
  end
end

get "/bread" do
  @title = "Elle Bread"
  haml :bread, locals: {
    breads: weekly_breads,
    email: nil,
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
    email: params[:email],
    items: items,
    name: params[:name],
    phone: params[:phone]
  )

  if honeypot_filled?
    haml :bread, locals: {
      breads: breads,
      email: nil,
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
      email: nil,
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
      email: params[:email],
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

not_found do
  @title = "Not found"
  haml :not_found
end
