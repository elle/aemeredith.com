require 'bundler'
Bundler.require(:default)

configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir = 'views'
    config.images_dir = File.join 'public', 'images'
  end

  set :sass, Compass.sass_engine_options
  set :scss, Compass.sass_engine_options
  set :haml, format: :html5
end

get '/application.css' do
  content_type 'text/css', charset: 'utf-8'
  scss :'stylesheets/application'
end

get '/' do
  haml :index
end
