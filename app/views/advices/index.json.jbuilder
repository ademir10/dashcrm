json.array!(@advices) do |advice|
  json.extract! advice, :id, :description, :type
  json.url advice_url(advice, format: :json)
end
