class CreateWeeklySelections < ActiveRecord::Migration[8.1]
  def change
    create_table :weekly_selections do |t|
      t.string :bread_id, null: false
      t.date :week_start, null: false
      t.timestamps
    end

    add_index :weekly_selections, %i[week_start bread_id], unique: true
  end
end
