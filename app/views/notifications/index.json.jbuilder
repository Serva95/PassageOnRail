json.array! @notifications do |notification|
  json.id notification.id
  json.user notification.user
  json.actor notification.actor.username
  json.notify_type notification.notify_type
  json.target do #notification.target
    json.type "a #{notification.target.class.to_s.underscore}"
  end
  json.url edit_driver_journey_path(notification.user, notification.target)
end