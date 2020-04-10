# Auto generate with notifications gem.
class Notification < ActiveRecord::Base
  include Notifications::Model

  belongs_to :user, class_name: "User"
  belongs_to :actor, class_name: "User"
  #belongs_to :notifiable, polymorphic: true

end
