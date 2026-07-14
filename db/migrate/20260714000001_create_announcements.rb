class CreateAnnouncements < ActiveRecord::Migration[8.1]
  def change
    create_table :announcements do |t|
      t.text :message, null: false
      t.timestamps
    end
  end
end
