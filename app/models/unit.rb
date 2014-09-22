class Unit < ActiveRecord::Base 
	validates :unitCode, presence:{ strict: true, message: 'is forgotten, click go back to import again.' }
	validates :unitName, presence:{ strict: true, message: 'is forgotten, click go back to import again.'  }
	validates :creditPoints, presence:{ strict: true, message: 'is forgotten, click go back to import again.'  }
	validates :semAvailable, presence:{ strict: true, message: 'is forgotten, click go back to import again.' }
	
	def self.import(file)
		arr = Array.new
      	ActiveRecord::Base.connection.execute("TRUNCATE units") 
		ActiveRecord::Base.connection.execute("TRUNCATE pre_req_groups") 
		ActiveRecord::Base.connection.execute("TRUNCATE pre_reqs")
	    CSV.foreach(file.path, headers: true) do |row|
			units =  find_by_id(row["id"]) || new
	    	units.attributes = row.to_hash.slice(*["id", "unitCode", "unitName", "preUnit", "creditPoints", "semAvailable"])
			if units.valid?
				units.save!
				unless units.preUnit.nil?
					
					pre_req_groups = units.pre_req_groups.find_by_unit_id(row["id"])|| units.pre_req_groups.new
					pre_req_groups.attributes = row.to_hash.slice(*["id", "unit_id"])
					pre_req_groups.save!
					
					
					arr = units.preUnit.to_s
					arr.split(/[^\w]/).map{ |s| s.to_s
					
					unless arr[s].empty?
					
						pre_reqs = units.pre_reqs.new
						pre_reqs.preUnit_code = arr[s]
						pre_reqs.pre_req_group_id = pre_req_groups.id
						pre_reqs.attributes = row.to_hash.slice(*["id","unit_id"])
						pre_reqs.save!
					end
					}
				end
			end
	    end
		return 1
	end

	def self.to_csv
		CSV.generate do |csv|
			csv << ["id", "unitCode", "unitName", "preUnit", "creditPoints", "semAvailable"]
			all.each do |unit|
				csv << unit.attributes.values_at(*["id", "unitCode", "unitName", "preUnit", "creditPoints", "semAvailable"])
			end
		end
	end

	def unit_to_s
		"#{unitCode} #{unitName}"
	end

	has_many :streamunits, :foreign_key=> :unit_id
	has_many :streams, through: :streamunits

	has_many :pre_reqs, :foreign_key=> :unit_id
	has_many :preUnits, through: :pre_reqs

	has_many :pre_req_groups, :foreign_key=> :unit_id

end
