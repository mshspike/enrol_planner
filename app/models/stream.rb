class Stream < ActiveRecord::Base		
	validates :streamCode, presence:{ strict: true, message: 'is forgotten, click go back to import again.' }
	validates :streamName, presence:{ strict: true, message: 'is forgotten, click go back to import again.' }
	validates :streamCode, uniqueness: { strict: true, message: 'not unique' }
	
	def self.import(file)
		spreadsheet = open_spreadsheet(file)
		
		arr = Array.new
		ActiveRecord::Base.connection.execute("TRUNCATE streams") 
		ActiveRecord::Base.connection.execute("TRUNCATE stream_units") 

		header = spreadsheet.row(1)
		(2..spreadsheet.last_row).each do |i|
		row = Hash[[header, spreadsheet.row(i)].transpose]
		#Import Data to Stream Table
		streams =  find_by_id(row["id"]) || new
	    streams.attributes = row.to_hash.slice(*["id", "streamCode", "streamName"])
			if streams.valid? 
				streams.save!
				
				arr2 = Array.new
				arr = row["units"]
				arr.split(/[^\w]/).map{ |a| a.to_s
				# To Get rid of empty index
					unless arr[a].empty?
						arr2.push(arr[a])
					end
					}
					#Import data to stream_units table
					(0..arr2.length-1).step(3).each do |c|
					# Create a new row in stream_units table
						stream_units = streams.stream_units.new
						stream_units.stream_id = streams.id
						aId = Unit.where(unitCode: arr2[c]).pluck(:id)
						stream_units.unit_id = aId.pop
						stream_units.plannedYear = arr2[c+1]
						stream_units.plannedSemester = arr2[c+2]
						stream_units.save!	
					
					end					
			end
		end	
		return 1	

	end

	def self.to_csv
		file = CSV.generate do |csv|
			csv << ["id", "streamCode", "streamName", "units"]
			all.each do |stream|
				stream_units = StreamUnit.where(:stream_id => stream.id)
				units 		 = Unit.where(:id => stream_units.pluck(:unit_id))

				unit_list_string = Array.new

				stream_units.each do |su|
					ucode = units.where(:id => su.unit_id).first.unitCode

					unit_string = "{" + ucode.to_s + "," + su.plannedYear.to_s + "," + su.plannedSemester.to_s + "}"
					unit_list_string.push(unit_string)
				end

				row = stream.attributes.values_at(*["id", "streamCode", "streamName"]).push(unit_list_string.join(';'))

				csv << row
			end
		end
	end

	def self.open_spreadsheet(file)
		case File.extname(file.original_filename)
			when ".csv" then Roo::Csv.new(file.path)
			when ".xls" then Roo::Excel.new(file.path)
			when ".xlsx" then Roo::Excelx.new(file.path)
		else 
			raise "You have imported an unknown file type: #{file.original_filename}."
		end
	end
	
	has_many :stream_units, :foreign_key=> :stream_id
	has_many :units, through:  :stream_units

end
