require "bundler"
require "yaml"
Bundler.require(:default)

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
