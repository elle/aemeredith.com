require "spec_helper"

require "models/order_item"

RSpec.describe OrderItem do
  describe ".from_line" do
    it "maps the line hash onto the item attributes" do
      item = OrderItem.from_line(
        id: "country",
        name: "Country sourdough",
        price: 9,
        quantity: 2
      )

      expect(item).to have_attributes(
        bread_id: "country",
        bread_name: "Country sourdough",
        quantity: 2,
        unit_price: 9
      )
    end
  end

  describe "#subtotal" do
    it "multiplies the quantity by the unit price" do
      item = OrderItem.new(quantity: 3, unit_price: 10)

      expect(item.subtotal).to eq(30)
    end
  end
end
