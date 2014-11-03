class Stream < ActiveRecord::Base		
	validates :streamCode, presence: { strict: true, message: " cannot be empty!" },
						   uniqueness: { strict: true, message: " is duplicated!" },
						   format: { :with => /\A[a-zA-Z]{4}-[a-zA-Z]{5}\z/i, message: " is in incorrect format!" }
	validates :streamName, presence: { strict: true, message: " cannot be empty!" }
	
################ START OF TASK EPW-214 ################
	def self.import(file)
		@proceed = false

		spreadsheet = open_spreadsheet(file)

		header = spreadsheet.row(1)

		if header.eql? ["id","streamCode","streamName","units"]
            @proceed = true
        else
            return 2
        end

		if @proceed
			ActiveRecord::Base.connection.execute("TRUNCATE streams")
			ActiveRecord::Base.connection.execute("TRUNCATE stream_units")

			stream_count = 0
			streams ||= []
			(2..spreadsheet.last_row).each do |i|
				srow = Hash[[header, spreadsheet.row(i)].transpose]

				unless Stream.where(:id => srow["id"].to_i).blank?
					# ID is  duplicate
					return 3
				end

				# Create new Stream object and ready for save
				streams[stream_count] = Stream.new
				streams[stream_count].attributes = srow.to_hash.slice(*["id", "streamCode", "streamName"])

				if (streams[stream_count].valid?)
					# Start validating units list format
					if (srow["units"] =~ /\A(\{\D{4}\d{4},[1-3]{1},[1-2]{1}\}){1}(;\{\D{4}\d{4},[1-3]{1},[1-2]{1}\})*\z/)
						# If number of above symbols are the same,
						# it indicates format is mostly correct.
						
						# Save stream
						stream = streams[stream_count]
						stream.save!

						# Start grabbing each unit from the units column string
						# Splitting each "node" into units array
						unit_array = srow["units"].split(';')

						# Foreach unit, further divide the node
						unit_array.each do |u|
							unit_info = u.scan(/\w+/)
							unit = Unit.where(:unitCode => unit_info[0])

							# Check if unit code exists
							unless (unit.blank?)
								uid = unit.first.id
								stream_unit = StreamUnit.new(:stream_id => stream.id, :unit_id => uid, \
															 :plannedYear => unit_info[1], :plannedSemester => unit_info[2])
								stream_unit.save!
							else
								# If unit code not exists, revert current saved stream and stop importing
								stream.delete
								# Unit Code not found
								return 6
							end

							# Increment to next stream row
							stream_count += 1
						end
					else
						# Incorrect units column format
						return 5
					end
				else
					# Incorrect Stream data
					return 4
				end
			end
		end
		# Import all succeed
		return 1
	end
################ END OF TASK EPW-214 ################

################ START OF TASK EPW-29 ################

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

################ END OF TASK EPW-29 ################

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
