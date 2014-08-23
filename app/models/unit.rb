class Unit < ActiveRecord::Base 
	validates :unitCode, presence:true
	validates :unitName, presence:true
	validates :creditPoints, presence:true
	validates :semAvailable, presence:true
	
	def self.import(file)
		Unit.delete_all
      	ActiveRecord::Base.connection.execute("TRUNCATE units") 
	    CSV.foreach(file.path, headers: true) do |row|
	    	Unit.create! row.to_hash
	    end
	end

	def self.to_csv
		CSV.generate do |csv|
			csv << ["unitCode", "unitName", "preUnit", "creditPoints", "semAvailable", "plannedYear"]
			all.each do |unit|
				csv << unit.attributes.values_at(*["unitCode", "unitName", "preUnit", "creditPoints", "semAvailable", "plannedYear"])
			end
		end
	end

	has_many :streamunits, :foreign_key=> :unit_id
	has_many :streams, through: :streamunits

	has_many :pre_reqs, :foreign_key=> :unit_id
	has_many :preUnits, through: :pre_reqs

	has_many :pre_req_groups, :foreign_key=> :unit_id

end
