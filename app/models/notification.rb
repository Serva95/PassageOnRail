class Notification < ApplicationRecord

  belongs_to :user, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :target, polymorphic: true
  belongs_to :second_target, polymorphic: true

  scope :unread, ->{ where(read_at: nil)}

  # crea le notifiche per i driver delle route prenotate
  def self.create_notifications_td(driver_id, actor, target, second_target, notify_type)
    user = User.where(driver_id: driver_id).first
    Notification.create! do |notification|
      notification.user = user
      notification.actor = actor
      notification.target = target
      notification.second_target = second_target
      notification.notify_type = notify_type
    end
  end

  # crea le notifiche per gli autostoppisti
  def self.create_notifications_th(user_id, actor, target, second_target, notify_type)
    user = User.find(user_id)
    Notification.create! do |notification|
      notification.user = user
      notification.actor = actor
      notification.target = target
      notification.second_target = second_target
      notification.notify_type = notify_type
    end
  end


end
