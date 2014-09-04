class Stream < ActiveRecord::Base
		
	validates :streamCode, presence:true
	validates :streamName, presence:true
	
	def self.import(file)
		Stream.delete_all
		ActiveRecord::Base.connection.execute("TRUNCATE streams") 
	    CSV.foreach(file.path, headers: true) do |row|
		streams =  find_by_id(row["id"]) || new
	    	streams.attributes = row.to_hash.slice(*["id", "streamCode", "streamName"])
			units.save!
    end

	end

	def self.to_csv
		file = CSV.generate do |csv|
			csv << ["id", "streamCode", "streamName"]
			all.each do |stream|
				csv << stream.attributes.values_at(*["id", "streamCode", "streamName"])
			end
		end
	end

	has_many :streamunits, :foreign_key=> :stream_id
	has_many :units, through:  :streamunits

end
