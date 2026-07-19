require "spec_helper"

require "app"

RSpec.describe OrderNotificationJob, :db do
  it "delivers the notification for the given order" do
    order = Order.create!(name: "Elle", phone: "0400123456", total: 0)
    allow(OrderNotification).to receive(:deliver)

    OrderNotificationJob.run(order.id)

    expect(OrderNotification).to have_received(:deliver).with(order)
  end
end
