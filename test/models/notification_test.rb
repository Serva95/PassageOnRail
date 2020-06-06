require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  test "#unread must return notifications unread" do
    n1 = notifications(:notifica1)
    n2 = notifications(:notifica2)
    assert_includes Notification.unread, n1
    assert_not_includes Notification.unread, n2
  end

  test "#create_notifications_td(driver_id, actor, target, second_target, notify_type) should create notifications for driver" do
    d = drivers(:one)
    user = users(:four)
    t1 = routes(:verona_milano)
    t2 = routes(:verona_milano)
    assert Notification.create_notifications_td(d.id,user,t1,t2,"reservation")
  end

  test "#create_notifications_th(user_id, actor, target, second_target, notify_type) should create notifications for driver" do
    d = users(:one)
    user = users(:four)
    t1 = routes(:verona_milano)
    t2 = routes(:verona_milano)
    assert Notification.create_notifications_th(user.id,d,t1,t2,"update")
  end
end