json.array! @notifications do |notification|
  json.user notification.user
  json.actor notification.actor.username
  json.notify_type notification.notify_type
  json.target notification.target_id
  json.url driver_route_path(notification.user, notification.second_target_id)
end