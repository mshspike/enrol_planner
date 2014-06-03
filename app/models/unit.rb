class Unit < ActiveRecord::Base 
	def self.import(file)
		Unit.delete_all
      	ActiveRecord::Base.connection.execute("TRUNCATE units") 
	    CSV.foreach(file.path, headers: true) do |row|
	    	Unit.create! row.to_hash
	    end
	end

	def self.to_csv
		CSV.generate do |csv|
			csv << ["unitCode", "unitName", "preUnit", "creditPoints", "semAvailable"]
			all.each do |unit|
				csv << unit.attributes.values_at(*["unitCode", "unitName", "preUnit", "creditPoints", "semAvailable"])
			end
		end
	end

	has_many :streamunits, :foreign_key=> :unit_id
	has_many :streams, through: :streamunits

	has_many :pre_reqs, :foreign_key=> :unit_id
	has_many :preUnits, through: :pre_reqs

end
