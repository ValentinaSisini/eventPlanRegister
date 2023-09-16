json.extract! event, :id, :user_id, :name, :start_datetime, :end_datetime, :location, :max_participants, :latitude, :longitude, :created_at, :updated_at
json.url event_url(event, format: :json)
