json.array!(@researches) do |research|
  json.extract! research, :id, :category_id, :user, :client, :cellphone
  json.url research_url(research, format: :json)
end
