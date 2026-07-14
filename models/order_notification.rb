require "mail"

class OrderNotification
  DEFAULT_FROM = "orders@aemeredith.com"
  DEFAULT_RECIPIENT = "elle@aemeredith.com"

  def self.deliver(order)
    new(order).deliver
  end

  def initialize(order)
    @order = order
  end

  def deliver
    message = build_message
    message.deliver
    message
  end

  private

  attr_reader :order

  def body
    <<~BODY
      New order from #{order.name} (#{order.phone}).

      #{line_items}

      Total: #{format("$%.2f", order.total)}
    BODY
  end

  def build_message
    recipient = ENV.fetch("ORDER_RECIPIENT", DEFAULT_RECIPIENT)
    sender = ENV.fetch("MAIL_FROM", DEFAULT_FROM)
    text = body
    subject_line = "New Elle Bread order from #{order.name}"

    Mail.new do
      from sender
      to recipient
      subject subject_line
      body text
    end
  end

  def line_items
    order.order_items.map do |item|
      format(
        "%d × %s — $%.2f",
        item.quantity,
        item.bread_name,
        item.subtotal
      )
    end.join("\n")
  end
end
