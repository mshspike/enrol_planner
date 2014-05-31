json.array!(@streams) do |stream|
  json.extract! stream, :id, :streamName, :streamCode
  json.url stream_url(stream, format: :json)
end
