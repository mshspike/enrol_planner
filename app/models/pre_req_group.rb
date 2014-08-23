class PreReqGroup < ActiveRecord::Base
  belongs_to :unit
  has_many :pre_reqs
  has_many :preUnits, through: :pre_reqs
end
