require "spec_helper"
require "base64"
require "mail"

require "config/mailgun_delivery"

RSpec.describe MailgunDelivery do
  describe "#deliver!" do
    it "posts the message to the Mailgun API with basic auth" do
      request = capture_request(mail)

      expect(request.path).to eq("/v3/mg.aemeredith.com/messages")
      expect(request["authorization"])
        .to eq("Basic #{Base64.strict_encode64("api:key-abc")}")
    end

    it "maps the message fields onto the API form" do
      body = capture_request(mail).body

      expect(body).to include("from=bread%40aemeredith.com")
      expect(body).to include("to=elle%40aemeredith.com")
      expect(body).to include("h%3AReply-To=buyer%40example.com")
    end

    context "when the API responds with an error" do
      it "raises" do
        stub_response(code: "401", body: "Unauthorized", success: false)

        expect { delivery.deliver!(mail) }
          .to raise_error(/Mailgun API returned 401/)
      end
    end
  end

  def delivery
    MailgunDelivery.new(
      api_key: "key-abc",
      domain: "mg.aemeredith.com"
    )
  end

  def mail
    Mail.new(
      from: "bread@aemeredith.com",
      reply_to: "buyer@example.com",
      subject: "New order",
      to: "elle@aemeredith.com"
    ) { body "Order details" }
  end

  def capture_request(message)
    captured = nil
    http = instance_double(Net::HTTP)
    allow(http).to receive(:request) do |request|
      captured = request
      success_response
    end
    allow(Net::HTTP).to receive(:start).and_yield(http).and_return(success_response)

    delivery.deliver!(message)
    captured
  end

  def stub_response(code:, body:, success:)
    response = Net::HTTPResponse.new("1.1", code, body)
    allow(response).to receive_messages(is_a?: success, body: body, code: code)
    http = instance_double(Net::HTTP, request: response)
    allow(Net::HTTP).to receive(:start).and_yield(http).and_return(response)
  end

  def success_response
    response = Net::HTTPResponse.new("1.1", "200", "OK")
    allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
    response
  end
end
