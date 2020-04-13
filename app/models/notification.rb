class Notification < ApplicationRecord

  belongs_to :user, class_name: "User"
  belongs_to :actor, class_name: "User"

  scope :unread, ->{ where(read_at: nil)}
end
