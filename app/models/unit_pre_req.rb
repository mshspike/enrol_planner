class UnitPreReq < ActiveRecord::Base
  belongs_to :prereq
  belongs_to :unit
end
