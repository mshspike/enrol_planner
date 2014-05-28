json.array!(@units) do |unit|
  json.extract! unit, :id, :unitCode, :unitName, :preUnit, :creditPoints, :semAvailable
  json.url unit_url(unit, format: :json)
end
