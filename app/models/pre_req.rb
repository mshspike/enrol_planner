class PreReq < ActiveRecord::Base
  belongs_to :preUnit, class_name:"Unit"
  belongs_to :unit
end
