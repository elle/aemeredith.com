require "spec_helper"

require "app"

RSpec.describe WeeklySelection, :db do
  describe ".replace" do
    it "stores the chosen bread ids for the current week" do
      WeeklySelection.replace(%w[country rye spelt])

      expect(WeeklySelection.current_bread_ids).to match_array(%w[country rye spelt])
    end

    it "caps the selection at three breads" do
      WeeklySelection.replace(%w[a b c d e])

      expect(WeeklySelection.current_bread_ids.length).to eq(3)
    end

    it "replaces the previous selection" do
      WeeklySelection.replace(%w[country rye spelt])
      WeeklySelection.replace(%w[field])

      expect(WeeklySelection.current_bread_ids).to eq(%w[field])
    end
  end

  describe ".current_bread_ids" do
    it "ignores selections from other weeks" do
      WeeklySelection.create!(
        bread_id: "old",
        week_start: WeeklySelection.week_start - 7
      )
      WeeklySelection.replace(%w[country])

      expect(WeeklySelection.current_bread_ids).to eq(%w[country])
    end
  end
end
