json.array!(@advices) do |advice|
  json.extract! advice, :id, :description
  json.url advice_url(advice, format: :json)
end
