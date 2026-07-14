require "active_record"

class WeeklySelection < ActiveRecord::Base
  MAX_BREADS = 3

  def self.current_bread_ids
    for_current_week.pluck(:bread_id)
  end

  def self.for_current_week
    where(week_start: week_start)
  end

  def self.replace(bread_ids)
    transaction do
      for_current_week.delete_all
      bread_ids.first(MAX_BREADS).each do |bread_id|
        create!(bread_id: bread_id, week_start: week_start)
      end
    end
  end

  def self.week_start
    Date.current.beginning_of_week
  end
end
