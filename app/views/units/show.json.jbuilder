json.extract! @unit, :id, :unitCode, :unitName, :preUnit, :creditPoints, :semAvailable
json.pre_req_groups @unit.pre_req_groups, :id, :preUnits