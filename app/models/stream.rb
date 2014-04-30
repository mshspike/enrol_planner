require 'active_record'
class Stream < ActiveRecord::Base
has_many :Unit , inverse_of: :Stream
end
