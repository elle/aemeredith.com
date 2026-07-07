require "spec_helper"
require "fileutils"
require "tmpdir"

require "post"

RSpec.describe Post do
  before do
    @posts_dir = Dir.mktmpdir
    stub_const("Post::POSTS_DIR", @posts_dir)
  end

  after do
    FileUtils.remove_entry(@posts_dir)
  end

  describe ".all" do
    it "returns posts newest first" do
      write_post(date: "2024-01-01", slug: "older")
      write_post(date: "2024-06-01", slug: "newer")

      slugs = Post.all.map(&:slug)

      expect(slugs).to eq(%w[newer older])
    end

    context "when two posts share a date" do
      it "orders them deterministically by slug" do
        write_post(date: "2024-05-05", slug: "beta")
        write_post(date: "2024-05-05", slug: "alpha")

        slugs = Post.all.map(&:slug)

        expect(slugs).to eq(%w[beta alpha])
      end
    end

    context "when a post has invalid frontmatter" do
      it "excludes it instead of raising" do
        write_post(date: "2024-01-01", slug: "good")
        write_invalid_post(slug: "broken")
        allow(Post).to receive(:warn)

        slugs = Post.all.map(&:slug)

        expect(slugs).to eq(%w[good])
      end
    end
  end

  describe ".find" do
    it "returns the post with the given slug" do
      write_post(slug: "hello-world", title: "Hello World")

      post = Post.find("hello-world")

      expect(post.title).to eq("Hello World")
    end

    context "when the slug does not exist" do
      it "returns nil" do
        expect(Post.find("missing")).to be_nil
      end
    end

    context "when the slug is not in slug format" do
      it "returns nil" do
        write_post(slug: "real")

        expect(Post.find("../real")).to be_nil
      end
    end
  end

  describe "date coercion" do
    context "when the date is quoted in the frontmatter" do
      it "still parses it as a Date" do
        write_post(date: '"2024-07-08"', slug: "quoted")

        post = Post.find("quoted")

        expect(post.date).to eq(Date.new(2024, 7, 8))
      end
    end
  end

  describe "#html" do
    it "renders the markdown body to HTML" do
      write_post(body: "# Title\n\nHello **world**.", slug: "post")

      html = Post.find("post").html

      expect(html).to include("<strong>world</strong>")
    end

    it "strips the leading heading so the title is not duplicated" do
      write_post(body: "# Title\n\nHello.", slug: "post", title: "Title")

      html = Post.find("post").html

      expect(html).not_to include("<h1")
    end
  end

  describe "#year" do
    it "returns the year of the date" do
      write_post(date: "2022-09-15", slug: "post")

      expect(Post.find("post").year).to eq(2022)
    end
  end

  def write_post(
    slug:,
    body: "# A Title\n\nBody paragraph.",
    date: "2024-01-02",
    title: "A Title"
  )
    File.write(
      File.join(@posts_dir, "#{slug}.md"),
      "---\ntitle: #{title}\ndate: #{date}\n---\n#{body}\n"
    )
  end

  def write_invalid_post(slug:)
    File.write(File.join(@posts_dir, "#{slug}.md"), "no frontmatter here\n")
  end
end
