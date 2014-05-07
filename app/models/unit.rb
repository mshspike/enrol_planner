class Unit < ActiveRecord::Base
	has_many :streamunits
	has_many :streams, through: :streamunits

	has_many :prereqs
	has_many :preUnits, through: :prereq

end
