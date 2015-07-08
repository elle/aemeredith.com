require "bundler"
Bundler.require(:default)

configure do
  set :haml, format: :html5
end

get '/application.css' do
  scss :"stylesheets/application"
end

get '/' do
  haml :index
end
