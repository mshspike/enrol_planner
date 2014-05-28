class Unit < ActiveRecord::Base

	def self.import(file)
	    CSV.foreach(file.path, headers: true) do |row|
	      Unit.create! row.to_hash
	    end
	end

	has_many :streamunits, :foreign_key=> :unit_id
	has_many :streams, through: :streamunits

	has_many :pre_reqs, :foreign_key=> :unit_id
	has_many :preUnits, through: :pre_reqs

end
