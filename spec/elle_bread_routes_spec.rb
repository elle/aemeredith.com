require "spec_helper"
require "rack/test"

require "app"

RSpec.describe "Elle Bread routes" do
  include Rack::Test::Methods

  describe "GET /bread" do
    it "renders the order form" do
      allow(WeeklySelection).to receive(:current_bread_ids).and_return([])

      get "/bread"

      expect(last_response).to be_ok
      expect(last_response.body).to include("Breads this")
    end
  end

  describe "POST /bread/orders" do
    context "when items and contact details are present" do
      it "places the order and shows a confirmation", :db do
        allow(WeeklySelection).to receive(:current_bread_ids).and_return([])
        allow(OrderNotification).to receive(:deliver)

        post "/bread/orders",
          items: { first_bread_id => "1" },
          name: "Elle",
          phone: "0400 123 456"

        expect(last_response).to be_ok
        expect(last_response.body).to include("Order received")
      end
    end

    context "when no items are selected" do
      it "responds with 422 and an error" do
        allow(WeeklySelection).to receive(:current_bread_ids).and_return([])

        post "/bread/orders", name: "Elle", phone: "0400 123 456"

        expect(last_response.status).to eq(422)
        expect(last_response.body).to include("at least one loaf")
      end
    end

    context "when the phone number is not ten digits" do
      it "responds with 422 and an error", :db do
        allow(WeeklySelection).to receive(:current_bread_ids).and_return([])

        post "/bread/orders",
          items: { first_bread_id => "1" },
          name: "Elle",
          phone: "12345"

        expect(last_response.status).to eq(422)
        expect(last_response.body).to include("10-digit")
      end
    end
  end

  describe "GET /bread/admin" do
    context "when not logged in" do
      it "redirects to the login page" do
        get "/bread/admin"

        expect(last_response).to be_redirect
        expect(last_response.location).to end_with("/bread/admin/login")
      end
    end
  end

  describe "POST /bread/admin/session" do
    around do |example|
      original = ENV["ADMIN_PASSWORD"]
      ENV["ADMIN_PASSWORD"] = "secret"
      example.run
      ENV["ADMIN_PASSWORD"] = original
    end

    context "when the password is correct" do
      it "redirects to the admin dashboard" do
        post "/bread/admin/session", password: "secret"

        expect(last_response).to be_redirect
        expect(last_response.location).to end_with("/bread/admin")
      end
    end

    context "when the password is incorrect" do
      it "responds with 401" do
        post "/bread/admin/session", password: "wrong"

        expect(last_response.status).to eq(401)
        expect(last_response.body).to include("Incorrect password")
      end
    end
  end

  describe "PUT /bread/admin/weekly-selection" do
    context "when not logged in" do
      it "redirects to the login page" do
        put "/bread/admin/weekly-selection", bread_ids: [first_bread_id]

        expect(last_response).to be_redirect
        expect(last_response.location).to end_with("/bread/admin/login")
      end
    end
  end

  def app
    Sinatra::Application
  end

  def first_bread_id
    BREADS.first["id"]
  end
end
