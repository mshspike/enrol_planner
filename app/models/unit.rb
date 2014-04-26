require 'active_record'
class Unit < ActiveRecord::Base
  belongs_to :Course, inverse_of: :unit
  has_and_belongs_to_many :preReqs,
  :class_name => "Unit",
  :association_foreign_key => "preReqs_id",
  :join_table => "preReqs_units"
end
