json.extract! notification, :id, :user_id, :event_id, :message, :datetime, :created_at, :updated_at
json.url notification_url(notification, format: :json)
