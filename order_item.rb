require "active_record"

class OrderItem < ActiveRecord::Base
  belongs_to :order

  validates :bread_id, presence: true
  validates :bread_name, presence: true
  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price, presence: true

  def self.from_line(item)
    new(
      bread_id: item[:id],
      bread_name: item[:name],
      quantity: item[:quantity],
      unit_price: item[:price]
    )
  end

  def subtotal
    quantity * unit_price
  end
end
