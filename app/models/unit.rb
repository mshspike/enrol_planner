class Unit < ActiveRecord::Base

	def self.import2(file)
	    CSV.foreach(file.path, headers: true) do |row|
	    	Unit.create! row.to_hash
	    end
	end

	def self.import(file)
		csv_text = File.read(file.path)
		csv = CSV.parse(csv_text,:headers => true)
		csv.each do |row|
			unit_code = csv.find {|row| row[:unitCode]}
			unit_code_db = Unit.find_by_unitCode(unit_code)
			puts unit_code_db.html_safe
	    	unless unit_code_db.nil?	    		
	    		Unit.update unit_code_db, row.to_hash
	    	else
	    		Unit.create! row.to_hash
	    	end
	    end
	end

	def self.to_csv
		CSV.generate do |csv|
			csv << column_names
			all.each do |unit|
				csv << unit.attributes.values_at(*column_names)
			end
		end
	end

	def self.to_pdf
		CSV.generate do |pdf|
			pdf << column_names
			all.each do |unit|
				pdf << unit.attributes.values_at(*column_names)
			end
		end
	end

	has_many :streamunits, :foreign_key=> :unit_id
	has_many :streams, through: :streamunits

	has_many :pre_reqs, :foreign_key=> :unit_id
	has_many :preUnits, through: :pre_reqs

end
