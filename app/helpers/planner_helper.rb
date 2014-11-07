module PlannerHelper
	
	def export_enrol_planner_csv
		#use a temporary array to generate csv
		rows = []
		#store the streamID, so the remaining units can be calculated upon import
		rows.push({:type => "S", :streamID => session[:selected_stream]})
		#store the planned units for each semester
		session[:semesters].each_with_index do |semUnits, semID|
			semUnits.each do |unitID|
				rows.push({:type => "P", :unitID => unitID, :semID => semID})
			end
		end
		#store the units already completed
		session[:done_units].each do |unitID|
			rows.push({:type => "D", :unitID => unitID})
		end
		#store the remaining units list
		session[:remain_units].each do |unitID|
			rows.push({:type => "R", :unitID => unitID})
		end
		#generate the csv
		csv = CSV.generate do |csv|
			rows.each do |row|
				csv << row.values
			end
		end
		return csv
	end
	
	def import_enrol_planner_csv csvdata
		#clear the enrolment planner session
		clear_enrolment_planner_session
		
		session[:done_units] = []
        session[:plan_units] = []
		session[:semesters] = []
		session[:remain_units] = []
		
		#parse csv into session
		CSV.foreach(csvdata.path) do |row|
			type = row[0]
			id = row[1].to_i
			if row[2]
				semID = row[2].to_i
			end
			if (type == "S")
				session[:selected_stream] = id
			elsif (type == "P")
				if (id != 0)
					session[:plan_units].push(id)
				end
				if (!session[:semesters][semID])
					session[:semesters][semID] = []
				end
				session[:semesters][semID].push(id)
			elsif (type == "D")
				session[:done_units].push(id)
			elsif (type == "R")
				session[:remain_units].push(id)
			end
		end
		
		# handle empty semester (first sem start)
		if session[:semesters].empty?
			session[:semesters]=[[]]
		elsif ((session[:semesters].count == 1) && (session[:semesters][0][0] == -1))
			# handle empty semester (second sem start)
			session[:semesters][1] = []
		end
		
		#populate remaining units for given stream
		#populate_remaining_units(session[:plan_units].concat(session[:done_units]))
		
		redirect_to enrolment_planner_planner_index_path, notice: "Session Restored Successfully"
		
	end
	
	def clear_enrolment_planner_session
		session.delete(:selected_stream)
        session.delete(:semesters)
        session.delete(:done_units)
        session.delete(:plan_units)
        session.delete(:remain_units)
        session.delete(:enrol_planner_flag)

        session.delete(:sem0_units)
        session.delete(:sem1_units)
        session.delete(:sem2_units)
        session.delete(:maths)
	end
	
	#assumes selected stream already stored in session
	def populate_remaining_units done_units_array
		@done_units = []
		session[:remain_units] = []
		# Get list of done units with ID integer
		unless done_units_array.nil?
			done_units_array.each do |puid|
				@done_units += StreamUnit.where(:stream_id => session[:selected_stream]).where(:unit_id => puid)
			end
		else
			@done_units = nil
		end
		
		# Get list of remaining units with done units object
		@remain_units = get_remaining_units(@done_units)
		
		# Assign remaining units' IDs to session variable
		@remain_units.each do |ru|
			session[:remain_units].push(ru.unit_id)
		end
		session[:remain_units].sort!
	end
	
	def get_remaining_units done
        # Get StreamUnit where SUs are in "selected stream", and ID is not in "done".
        # Note that where() method returns ActiveRecord object, even if the result is
        # only one entry, it return an ActiveRecord array.
        unless done.nil?
            remain_streamunits = StreamUnit.where(:stream_id => session[:selected_stream]).where('id not in (?)', done)
		else
            remain_streamunits = StreamUnit.where(:stream_id => session[:selected_stream])
        end
        return remain_streamunits
    end
	
end
