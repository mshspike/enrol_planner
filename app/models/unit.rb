class Unit < ActiveRecord::Base
	has_many :stream_units
	has_many :streams, through: :stream_units

	has_many :pre_reqs
	has_many :preUnits, through: :pre_reqs

end
