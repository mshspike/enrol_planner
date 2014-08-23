json.extract! @unit, :id, :unitCode, :unitName, :preUnit, :creditPoints, :semAvailable, :created_at, :updated_at
json.pre_req_groups @unit.pre_req_groups, :id, :preUnits