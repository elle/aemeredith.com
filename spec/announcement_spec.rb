require "spec_helper"

require "app"

RSpec.describe Announcement, :db do
  describe ".set" do
    it "stores the message" do
      Announcement.set("Fresh loaves this Friday")

      expect(Announcement.current.message).to eq("Fresh loaves this Friday")
    end

    it "keeps only one announcement" do
      Announcement.set("First")
      Announcement.set("Second")

      expect(Announcement.count).to eq(1)
      expect(Announcement.current.message).to eq("Second")
    end

    it "strips surrounding whitespace" do
      Announcement.set("  Closed next week  ")

      expect(Announcement.current.message).to eq("Closed next week")
    end

    context "when the message is blank" do
      it "clears the announcement" do
        Announcement.set("Something")
        Announcement.set("   ")

        expect(Announcement.current).to be_nil
      end
    end
  end
end
