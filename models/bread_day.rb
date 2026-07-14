require "date"

class BreadDay
  DAYS_FROM_WEEK_START = 4

  def self.for_week_of(date)
    new(date.beginning_of_week + DAYS_FROM_WEEK_START)
  end

  def initialize(date)
    @date = date
  end

  def heading
    "Breads this #{date.strftime("%A, %B")} #{ordinal_day}:"
  end

  private

  attr_reader :date

  def ordinal_day
    "#{date.day}#{ordinal_suffix}"
  end

  def ordinal_suffix
    if (11..13).cover?(date.day % 100)
      "th"
    elsif date.day % 10 == 1
      "st"
    elsif date.day % 10 == 2
      "nd"
    elsif date.day % 10 == 3
      "rd"
    else
      "th"
    end
  end
end
