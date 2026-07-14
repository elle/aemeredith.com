require "active_record"

class Order < ActiveRecord::Base
  PHONE_LENGTH = 10

  has_many :order_items, dependent: :destroy

  validates :name, presence: true
  validates :phone,
    length: { is: PHONE_LENGTH, message: "must be a 10-digit number" }

  def self.build(items:, name:, phone:)
    new(
      name: name,
      order_items: items.map { |item| OrderItem.from_line(item) },
      phone: phone,
      total: items.sum { |item| item[:quantity] * item[:price] }
    )
  end

  def self.place(items:, name:, phone:)
    build(items: items, name: name, phone: phone).tap(&:save!)
  end

  def self.recent
    order(created_at: :desc)
  end

  def name=(value)
    super(value.to_s.strip)
  end

  def phone=(value)
    super(value.to_s.gsub(/\D/, ""))
  end
end
