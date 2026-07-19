source "https://rubygems.org"
ruby File.read(".ruby-version").strip

gem "activerecord"
gem "haml"
gem "kramdown"
gem "mail"
gem "pg"
gem "puma"
gem "que"
gem "rack-attack"
gem "rackup"
gem "rake"
gem "sass"
gem "sinatra"
gem "sinatra-activerecord"

group :development, :test do
  gem "dotenv"
end

group :development do
  gem "foreman", require: false
end

group :test do
  gem "rack-test"
  gem "rspec"
end

