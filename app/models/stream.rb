require 'active_record'
class Stream < ActiveRecord::Base
  has_many :streamsunits
  has_many :units, through: :streamsunits
  
  
  #has_many :Unit , inverse_of: :Stream
end
