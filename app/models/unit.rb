require 'active_record'
class Unit < ActiveRecord::Base
  has_many :streamunits
  has_many :streams, through: :streamunits
  
  has_many :requires
  has_many :preUnits, through: :requires
  
 # belongs_to :stream, inverse_of: :unit
 # has_many :preReqs, :class_name => "Unit",
 # :foreign_key => "parent_unit_id"
 # belongs_to :parent_unit, :class_name => "Unit",
 # :foreign_key => "parent_unit_id"
end
