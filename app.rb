require "bundler"
require "yaml"
Bundler.require(:default)
require_relative "post"

configure do
  set :haml, format: :html5
end

TALKS = YAML.load_file("data/talks.yml").freeze
TESTIMONIALS = YAML.load_file("data/testimonials.yml").freeze

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
