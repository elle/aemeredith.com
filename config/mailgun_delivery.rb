require "net/http"
require "uri"

# A Mail delivery method that sends through Mailgun's HTTP API with an API
# sending key, instead of SMTP. Registered via `Mail.defaults`.
class MailgunDelivery
  DEFAULT_BASE_URL = "https://api.mailgun.net"

  attr_reader :settings

  def initialize(settings)
    @settings = settings
  end

  def deliver!(mail)
    uri = URI("#{base_url}/v3/#{domain}/messages")
    request = Net::HTTP::Post.new(uri)
    request.basic_auth("api", api_key)
    request.set_form_data(form_fields(mail))

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    unless response.is_a?(Net::HTTPSuccess)
      raise "Mailgun API returned #{response.code}: #{response.body}"
    end

    mail
  end

  private

  def api_key
    settings[:api_key]
  end

  def base_url
    settings[:base_url] || DEFAULT_BASE_URL
  end

  def domain
    settings[:domain]
  end

  def form_fields(mail)
    fields = {
      "from" => mail.from.join(","),
      "to" => mail.to.join(","),
      "subject" => mail.subject.to_s,
      "text" => mail.body.decoded,
    }

    unless mail.reply_to.nil?
      fields["h:Reply-To"] = mail.reply_to.join(",")
    end

    fields
  end
end
