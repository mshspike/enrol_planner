class PreReq < ActiveRecord::Base
  belongs_to :preUnit, class_name: 'Unit', :foreign_key=> :preUnit_code, :primary_key=> :unitCode
  belongs_to :unit, :foreign_key=> :unit_id, :primary_key=> :id
  belongs_to :pre_req_group, :foreign_key=> :id, :primary_key => :group
end
