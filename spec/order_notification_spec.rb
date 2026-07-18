require "spec_helper"

require "app"

RSpec.describe OrderNotification do
  describe ".deliver" do
    it "addresses the notification to the order recipient" do
      message = OrderNotification.deliver(order)

      expect(message.to).to eq(["elle@aemeredith.com"])
      expect(message.subject).to eq("New Elle Bread order from Elle")
    end

    it "includes the customer, line items and total in the body" do
      message = OrderNotification.deliver(order)
      body = message.body.to_s

      expect(body).to include("New order from Elle")
      expect(body).to include("Phone: 0400000000")
      expect(body).to include("Email: elle@example.com")
      expect(body).to include("2 × Country sourdough — $18.00")
      expect(body).to include("Total: $18.00")
    end

    it "sets reply-to to the customer email" do
      message = OrderNotification.deliver(order)

      expect(message.reply_to).to eq(["elle@example.com"])
    end

    context "when the order has no email" do
      it "notes it is not provided and sets no reply-to" do
        message = OrderNotification.deliver(order(email: nil))

        expect(message.body.to_s).to include("Email: (not provided)")
        expect(message.reply_to).to be_nil
      end
    end
  end

  def order(email: "elle@example.com")
    Order.new(
      email: email,
      name: "Elle",
      order_items: [
        OrderItem.new(
          bread_name: "Country sourdough",
          quantity: 2,
          unit_price: 9
        ),
      ],
      phone: "0400 000 000",
      total: 18
    )
  end
end
