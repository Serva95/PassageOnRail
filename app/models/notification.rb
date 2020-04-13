class Notification < ApplicationRecord

  belongs_to :user, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :target, polymorphic: true
  belongs_to :second_target, polymorphic: true

  scope :unread, ->{ where(read_at: nil)}


end
