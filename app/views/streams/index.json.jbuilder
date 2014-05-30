json.array!(@streams) do |stream|
  json.extract! stream, :id, :streanName, :streamCode
  json.url stream_url(stream, format: :json)
end
