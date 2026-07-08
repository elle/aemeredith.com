class CreateOrdersAndItems < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.string :name, null: false
      t.string :phone, null: false
      t.decimal :total, precision: 8, scale: 2, null: false, default: 0
      t.string :status, null: false, default: "unpaid"
      t.timestamps
    end

    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.string :bread_id, null: false
      t.string :bread_name, null: false
      t.decimal :unit_price, precision: 8, scale: 2, null: false
      t.integer :quantity, null: false
      t.timestamps
    end
  end
end
