json.array!(@results) do |result|
  json.extract! result, :id, :a1, :a2, :a3, :a4, :a5, :a6, :a7, :a8, :a9, :a10, :a11, :a12, :a13, :a14, :a15, :research_id
  json.url result_url(result, format: :json)
end
