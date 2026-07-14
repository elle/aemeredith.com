require "active_record"

class Announcement < ActiveRecord::Base
  validates :message, presence: true

  def self.current
    first
  end

  def self.set(message)
    cleaned = message.to_s.strip

    transaction do
      delete_all
      unless cleaned.empty?
        create!(message: cleaned)
      end
    end
  end
end
