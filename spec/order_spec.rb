require "spec_helper"

require "app"

RSpec.describe Order, :db do
  describe ".place" do
    it "persists the order with the customer details" do
      order = Order.place(items: [line], name: "Elle", phone: "0400 000 000")

      expect(order).to be_persisted
      expect(order.name).to eq("Elle")
      expect(order.phone).to eq("0400 000 000")
    end

    it "computes the total from the line items" do
      order = Order.place(
        items: [line(price: 10, quantity: 2), line(id: "rye", price: 9)],
        name: "Elle",
        phone: "0400 000 000"
      )

      expect(order.total).to eq(29)
    end

    it "builds an order item per line" do
      order = Order.place(items: [line], name: "Elle", phone: "0400 000 000")

      expect(order.order_items.map(&:bread_name)).to eq(["Country sourdough"])
    end
  end

  describe ".recent" do
    it "returns orders newest first" do
      older = place(name: "Older")
      newer = place(name: "Newer")
      older.update!(created_at: Time.now - 86_400)

      expect(Order.recent.to_a).to eq([newer, older])
    end
  end

  def line(id: "country", name: "Country sourdough", price: 9, quantity: 1)
    { id: id, name: name, price: price, quantity: quantity }
  end

  def place(name:)
    Order.place(items: [line], name: name, phone: "0400 000 000")
  end
end
