class PreReq < ActiveRecord::Base
  belongs_to :preUnit, class_name: 'Unit', :foreign_key=> :preUnit_id, :primary_key=> :preUnit_id
  belongs_to :unit, :foreign_key=> :unit_id, :primary_key=> :unit_id
end
