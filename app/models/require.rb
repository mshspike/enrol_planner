class Require < ActiveRecord::Base
  belongs_to :unit
  belongs_to :preUnit, class_name:'Unit'
  
end
