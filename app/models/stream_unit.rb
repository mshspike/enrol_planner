class StreamUnit < ActiveRecord::Base

	def self.import(file)
		StreamUnit.delete_all
		ActiveRecord::Base.connection.execute("TRUNCATE stream_units") 
	    CSV.foreach(file.path, headers: true) do |row|
	    	StreamUnit.create! row.to_hash
    end
	end

	def self.to_csv
		file = CSV.generate do |csv|
			csv << ["stream_id", "unit_id"]
			all.each do |stream_unit|
				csv << stream_unit.attributes.values_at(*["stream_id", "unit_id"])
			end
		end
	end

  belongs_to :stream, :foreign_key=>:stream_id, :primary_key=> :stream_id, inverse_of: :streamunits
  belongs_to :unit, :foreign_key=> :unit_id, :primary_key=> :unit_id, inverse_of: :Unit

  #delegate :stream_id, to: :stream

  #belongs_to :stream, :foreign_key => :stream_id
  #belongs_to :unit, :foreign_key => :unit_id

  def stream_Name
  	stream.streamName
  end

  def unit_Name
  	unit.unitName
  end

end
