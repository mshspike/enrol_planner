class Stream < ActiveRecord::Base		
	validates :streamCode, presence:{ strict: true, message: 'is forgotten, click go back to import again.' }
	validates :streamName, presence:{ strict: true, message: 'is forgotten, click go back to import again.' }
	validates :streamCode, uniqueness: { strict: true, message: 'not unique' }
	
	def self.import(file)
	
		spreadsheet = open_spreadsheet(file)
		ActiveRecord::Base.connection.execute("TRUNCATE streams") 
		
		header = spreadsheet.row(1)
		(2..spreadsheet.last_row).each do |i|
		row = Hash[[header, spreadsheet.row(i)].transpose]
		streams =  find_by_id(row["id"]) || new
	    	streams.attributes = row.to_hash.slice(*["id", "streamCode", "streamName"])
			if streams.valid? 
				streams.save!
			end
		end
		return 1
	end

	def self.to_csv
		file = CSV.generate do |csv|
			csv << ["id", "streamCode", "streamName"]
			all.each do |stream|
				csv << stream.attributes.values_at(*["id", "streamCode", "streamName"])
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
	
	has_many :streamunits, :foreign_key=> :stream_id
	has_many :units, through:  :streamunits

end
