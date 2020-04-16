json.array! @chats do |chat|
  if current_user.id == chat.user_1_id
    if chat.updated_at > chat.open_time_user_1
      json.id chat.id
    end
  else
    if chat.updated_at > chat.open_time_user_2
      json.id chat.id
    end
  end
end