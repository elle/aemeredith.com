require "spec_helper"
require "rack/test"

require "app"

RSpec.describe "Article routes" do
  include Rack::Test::Methods

  describe "GET /articles" do
    it "renders the list of posts" do
      allow(Post).to receive(:all).and_return([sample_post])

      get "/articles"

      expect(last_response).to be_ok
      expect(last_response.body).to include("A Sample Post")
    end
  end

  describe "GET /articles/:slug" do
    context "when the post exists" do
      it "renders the post" do
        allow(Post).to receive(:find)
          .with("a-sample-post")
          .and_return(sample_post)

        get "/articles/a-sample-post"

        expect(last_response).to be_ok
        expect(last_response.body).to include("A Sample Post")
      end
    end

    context "when the post does not exist" do
      it "responds with 404" do
        allow(Post).to receive(:find).and_return(nil)

        get "/articles/does-not-exist"

        expect(last_response).to be_not_found
      end
    end
  end

  def app
    Sinatra::Application
  end

  def sample_post
    Post.new(
      body: "Body paragraph.",
      date: Date.new(2024, 3, 1),
      description: "A description.",
      slug: "a-sample-post",
      title: "A Sample Post"
    )
  end
end
