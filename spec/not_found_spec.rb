require "spec_helper"
require "rack/test"

require "app"

RSpec.describe "Unknown routes" do
  include Rack::Test::Methods

  it "renders the styled 404 page" do
    get "/no-such-page"

    expect(last_response).to be_not_found
    expect(last_response.body).to include("Not found")
  end

  def app
    Sinatra::Application
  end
end
