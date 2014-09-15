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
		#generate the csv
		csv = CSV.generate do |csv|
			rows.each do |row|
				csv << row.values
			end
		end
		return csv
	end
	
	def import_enrol_planner_csv
		#clear the enrolment planner session
		clear_enrolment_planner_session
		
		#
	end
	
	def clear_enrolment_planner_session
		session.delete(:selected_stream)
        session.delete(:semesters)
        session.delete(:done_units)
        session.delete(:plan_units)
        session.delete(:remain_units)
        session.delete(:enrol_planner_flag)
	end
	
end
