require "active_record"

class Order < ActiveRecord::Base
  has_many :order_items, dependent: :destroy

  validates :name, presence: true
  validates :phone, presence: true

  def self.place(items:, name:, phone:)
    create!(
      name: name,
      order_items: items.map { |item| OrderItem.from_line(item) },
      phone: phone,
      total: items.sum { |item| item[:quantity] * item[:price] }
    )
  end

  def self.recent
    order(created_at: :desc)
  end
end
