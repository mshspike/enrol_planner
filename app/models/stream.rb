class Stream < ActiveRecord::Base
		
	validates :streamCode, presence:true
	validates :streamName, presence:true
	
	def self.import(file)
		Stream.delete_all
		ActiveRecord::Base.connection.execute("TRUNCATE streams") 
	    CSV.foreach(file.path, headers: true) do |row|
	    	Stream.create! row.to_hash
    end

	end

	def self.to_csv
		file = CSV.generate do |csv|
			csv << ["streamCode", "streamName"]
			all.each do |stream|
				csv << stream.attributes.values_at(*["streamCode", "streamName"])
			end
		end
	end

	has_many :streamunits, :foreign_key=> :stream_id
	has_many :units, through:  :streamunits

end
