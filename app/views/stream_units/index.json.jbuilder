json.array!(@stream_units) do |stream_unit|
  json.extract! stream_unit, :id, :stream_id, :unit_id
  json.url stream_unit_url(stream_unit, format: :json)
end
