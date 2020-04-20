json.array! @notifications do |notification|
  json.id notification.id
  json.user notification.user
  json.actor notification.actor.username
  json.notify_type notification.notify_type
  json.target do #notification.target
    json.type "a #{notification.target.class.to_s.underscore}"
  end
  if notification.notify_type == 'reservation'
    json.url edit_driver_journey_path(notification.user, notification.target, route: notification.second_target.id)
  elsif notification.notify_type == 'accepted'
    json.url user_bookings_path(notification.user)
  elsif notification.notify_type == 'rejected'
    json.url new_search_path(c_part: notification.second_target.citta_partenza,c_arr: notification.second_target.citta_arrivo,data_ora: notification.second_target.data_ora_partenza)
  elsif notification.notify_type == 'updated'
    json.url detail_routes_path(multitrip: false, id: notification.second_target.id, j_id: notification.target.id)
  elsif notification.notify_type == 'deleted'
    json.url new_search_path
  end
end