class Stream < ActiveRecord::Base
	has_many :streamunits
	has_many :units, through: :streamunits
end
