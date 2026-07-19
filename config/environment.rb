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

require_relative "../models/announcement"
require_relative "../models/bread_day"
require_relative "../models/post"
require_relative "../models/order"
require_relative "../models/order_item"
require_relative "../models/order_notification"
require_relative "../models/weekly_selection"

# Background jobs run on Que, piggybacking on Active Record's connection.
Que.connection = ActiveRecord
require_relative "../jobs/order_notification_job"

DEV_SESSION_SECRET =
  "a-development-session-secret-that-is-long-enough-0000000000000000"

configure do
  # Config lives in config/, so anchor views and public/ to the project root.
  set :root, File.expand_path("..", __dir__)
  set :haml, format: :html5
  set :session_secret, ENV.fetch("SESSION_SECRET", DEV_SESSION_SECRET)
  enable :sessions
  # Serve the PWA web manifest with its proper content type.
  Rack::Mime::MIME_TYPES[".webmanifest"] = "application/manifest+json"
end

# Guard the forms with CSRF tokens everywhere except the test suite, which
# follows the convention of disabling forgery protection for request specs.
configure :production, :development do
  use Rack::Protection::AuthenticityToken
end

configure :production do
  # Mailgun's Heroku add-on sets the MAILGUN_SMTP_* vars automatically; fall
  # back to generic SMTP_* names if a different provider is set up by hand.
  Mail.defaults do
    delivery_method :smtp,
      address: ENV["MAILGUN_SMTP_SERVER"] || ENV["SMTP_ADDRESS"],
      port: ENV["MAILGUN_SMTP_PORT"] || ENV.fetch("SMTP_PORT", 587),
      user_name: ENV["MAILGUN_SMTP_LOGIN"] || ENV["SMTP_USERNAME"],
      password: ENV["MAILGUN_SMTP_PASSWORD"] || ENV["SMTP_PASSWORD"],
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
  Que.run_synchronously = true
end

TALKS = YAML.load_file("data/talks.yml").freeze
TESTIMONIALS = YAML.load_file("data/testimonials.yml").freeze
BREADS = YAML.load_file("data/breads.yml").freeze
# Fallback when the admin hasn't chosen this week's breads yet.
WEEKLY_BREAD_IDS = BREADS.first(3).map { |bread| bread["id"] }.freeze
