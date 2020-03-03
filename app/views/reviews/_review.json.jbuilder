json.extract! review, :id, :data, :rating, :commento, :deleted, :created_at, :updated_at
json.url review_url(review, format: :json)
