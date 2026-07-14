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

      expect(body).to include("Elle (0400 000 000)")
      expect(body).to include("2 × Country sourdough — $18.00")
      expect(body).to include("Total: $18.00")
    end
  end

  def order
    Order.new(
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
