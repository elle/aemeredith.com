require "date"
require "kramdown"
require "yaml"

class Post
  POSTS_DIR = File.expand_path("../posts", __dir__)
  SLUG_FORMAT = /\A[a-z0-9-]+\z/

  attr_reader :date, :description, :slug, :title

  def self.all
    Dir.glob(File.join(POSTS_DIR, "*.md"))
      .filter_map { |path| from_file(path) }
      .sort_by { |post| [post.date, post.slug] }
      .reverse
  end

  def self.find(slug)
    path = File.join(POSTS_DIR, "#{slug}.md")

    if slug.match?(SLUG_FORMAT) && File.exist?(path)
      from_file(path)
    end
  end

  def self.from_file(path)
    _, frontmatter, body = File.read(path).split(/^---\s*$\n/, 3)
    meta = YAML.safe_load(frontmatter.to_s, permitted_classes: [Date])

    if meta.is_a?(Hash) && meta["title"] && meta["date"]
      new(
        body: body.to_s,
        date: Date.parse(meta["date"].to_s),
        description: meta["description"],
        slug: File.basename(path, ".md"),
        title: meta["title"]
      )
    else
      warn "Skipping post with invalid frontmatter: #{path}"
      nil
    end
  rescue Psych::SyntaxError, ArgumentError => error
    warn "Skipping post with invalid frontmatter: #{path} (#{error.message})"
    nil
  end

  def initialize(body:, date:, description:, slug:, title:)
    @body = body
    @date = date
    @description = description
    @slug = slug
    @title = title
  end

  def html
    Kramdown::Document.new(body_without_leading_heading).to_html
  end

  def year
    date.year
  end

  private

  attr_reader :body

  def body_without_leading_heading
    body.sub(/\A\s*#{'#'}{1,6}\s+.*(?:\n|\z)/, "")
  end
end
