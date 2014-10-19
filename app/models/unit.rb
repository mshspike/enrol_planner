class Unit < ActiveRecord::Base 
	validates :unitCode, presence:{ strict: true, message: 'is forgotten, click go back to import again.' }
	validates :unitName, presence:{ strict: true, message: 'is forgotten, click go back to import again.'  }
	validates :creditPoints, presence:{ strict: true, message: 'is forgotten, click go back to import again.'  }
	validates :semAvailable, presence:{ strict: true, message: 'is forgotten, click go back to import again.' }
	validates_length_of :unitCode, :within => 3..10, :too_long => "Invalid Unit Code", :too_short => "Invalid Unit Code"
	validates_length_of :unitName, :within => 5..100, :too_long => "Invalid Unit Name", :too_short => "Invalid Unit Name"
	validates_numericality_of :creditPoints,  :less_than_or_equal_to => 50
	validates_numericality_of :semAvailable,  :less_than_or_equal_to => 2	
	validates :unitCode, uniqueness: { strict: true, message: 'not unique' }
	

	def self.import(file)
	
		#Validates the file type
		spreadsheet = open_spreadsheet(file)

			arr = Array.new
			# Resetting the model to avoid duplication 
			ActiveRecord::Base.connection.execute("TRUNCATE units") 
			ActiveRecord::Base.connection.execute("TRUNCATE pre_req_groups") 
			ActiveRecord::Base.connection.execute("TRUNCATE pre_reqs")
		
			#Header of the spreadsheet is the name of the attributes
			header = spreadsheet.row(1)
			
			#Import the data line by line
			(2..spreadsheet.last_row).each do |i|
			row = Hash[[header, spreadsheet.row(i)].transpose]
			units =  find_by_id(row["id"]) || new
	    	units.attributes = row.to_hash.slice(*["id", "unitCode", "unitName", "preUnit", "creditPoints", "semAvailable"])
			# Validates the data of the spreadsheet, save the data into the database if it is valid data.
			if units.valid? 
				units.save!
				
				# Check if the unit has pre-requisite
				unless units.preUnit.nil?
					
					#Unit that has pre-requisite unit, the unit will be stored in the pre_req_groups table if the unit is not exist in the table.
					pre_req_groups = units.pre_req_groups.find_by_unit_id(row["id"])|| units.pre_req_groups.new
					pre_req_groups.attributes = row.to_hash.slice(*["id", "unit_id"])
					pre_req_groups.save!
					
					#Push all the pre-requisite unit code in an array and split by any symbols
					arr = units.preUnit.to_s
					arr.split(/[^\w]/).map{ |s| s.to_s
					
					# if the index has pre-requisite unit code, store it to the pre_reqs table.
					unless arr[s].empty?
						pre_reqs = units.pre_reqs.new
						pre_reqs.preUnit_code = arr[s]
						pre_reqs.pre_req_group_id = pre_req_groups.id
						pre_reqs.attributes = row.to_hash.slice(*["id","unit_id"])
						pre_reqs.save!
					end
					}
				end
			end #for if
			end #For do
		return 1	# if imported successfully , return 1
	end

	def self.to_csv
		CSV.generate do |csv|
			csv << ["id", "unitCode", "unitName", "preUnit", "creditPoints", "semAvailable"]
			all.each do |unit|
				csv << unit.attributes.values_at(*["id", "unitCode", "unitName", "preUnit", "creditPoints", "semAvailable"])
			end
		end
	end
	
	def self.open_spreadsheet(file)
		#check the file extension to verity if it is a valid import file type.
		case File.extname(file.original_filename)
			when ".csv" then Roo::Csv.new(file.path)
			when ".xls" then Roo::Excel.new(file.path)
			when ".xlsx" then Roo::Excelx.new(file.path)
		else 
			raise "You have imported an unknown file type: #{file.original_filename}."
		end
	end	
	

	def unit_to_s
		"#{unitCode} #{unitName}"
	end

	has_many :stream_units, :foreign_key=> :unit_id
	has_many :streams, through: :stream_units

	has_many :pre_reqs, :foreign_key=> :unit_id
	has_many :preUnits, through: :pre_reqs

	has_many :pre_req_groups, :foreign_key=> :unit_id
	validates_uniqueness_of :unitCode
end
