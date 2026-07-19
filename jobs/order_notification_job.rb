require "que"

class OrderNotificationJob < Que::Job
  def run(order_id)
    order = Order.find(order_id)
    OrderNotification.deliver(order)
  end
end
