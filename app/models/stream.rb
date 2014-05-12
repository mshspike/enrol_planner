class Stream < ActiveRecord::Base
	has_many :streamunits, :foreign_key=> :stream_id
	has_many :units, through:  :streamunits
end
