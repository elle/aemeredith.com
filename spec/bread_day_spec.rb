require "spec_helper"

require "app"

RSpec.describe BreadDay do
  describe ".for_week_of" do
    it "uses the Friday of that week" do
      heading = BreadDay.for_week_of(Date.new(2026, 7, 8)).heading

      expect(heading).to eq("Breads this Friday, July 10th:")
    end

    it "stays on the same week's Friday over the weekend" do
      heading = BreadDay.for_week_of(Date.new(2026, 7, 11)).heading

      expect(heading).to eq("Breads this Friday, July 10th:")
    end
  end

  describe "#heading" do
    it "adds the correct ordinal suffix" do
      expect(headings_for(1, 2, 3, 4, 11, 12, 13, 21, 22, 23)).to eq(
        %w[1st 2nd 3rd 4th 11th 12th 13th 21st 22nd 23rd]
      )
    end
  end

  def headings_for(*days)
    days.map do |day|
      BreadDay.new(Date.new(2026, 3, day)).heading[/\d+\w+/]
    end
  end
end
