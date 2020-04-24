json.extract! contribucion, :id, :user_id, :title, :url, :text, :created_at, :updated_at
json.url contribucion_url(contribucion, format: :json)
