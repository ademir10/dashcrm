json.array!(@quizzes) do |quiz|
  json.extract! quiz, :id, :category_id, :question, :score
  json.url quiz_url(quiz, format: :json)
end
