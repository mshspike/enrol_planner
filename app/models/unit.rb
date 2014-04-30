require 'active_record'
class Unit < ActiveRecord::Base
  belongs_to :Course, inverse_of: :unit
  has_many :preReqs, :class_name => "Unit",
	:foreign_key => "parent_unit_id"
  belongs_to :parent_unit, :class_name => "Unit",
	:foreign_key => "parent_unit_id"
end
