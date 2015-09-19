json.array!(@answers) do |answer|
  json.extract! answer, :id, :content, :poll_id
  json.url answer_url(answer, format: :json)
end
