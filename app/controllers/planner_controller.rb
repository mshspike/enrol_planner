class PlannerController < ApplicationController
	@stream_units

	helper_method :get_streamunit_name, :get_stream_name

# START stream_chooser
	def index
		@streams = Stream.all

		# Clear all seesion variables to avoid messing with previous data
		session.delete(:selected_stream)
		session.delete(:semesters)
		session.delete(:done_units)
		session.delete(:remain_units)
	end

	def get_stream_name sid
		s = Stream.find_by_id(sid)
		return s.streamName
	end

# END stream_chooser


# START unit_chooser
	def unit_chooser
		@str = Stream.find_by_id(params["streamSelect"])

		#declare session variable and store selected stream id to it
		session[:selected_stream] = @str.id

		
		@stream_units = getStreamUnits(@str)
	end

	def get_streamunit_name uid
		u = Unit.find_by_id(uid)
		return u.unitName
	end

	def getStreamUnits chosen_stream
		streamunits_list = StreamUnit.where(:stream_id => chosen_stream)
		# units_list = Unit.where(:id => streamunits_list)
		return streamunits_list
	end
# END unit_chooser


# START enrolment_planner
	def enrolment_planner
		@done_units = []
		session[:done_units] = params[:unit_ids]
		session[:remain_units] = []

		# START initialising session[:semesters]
		session[:semesters]=[]
		session[:semesters][0] = []
		session[:semesters][0][0] = 0
		# END initialising

		session[:semesters][0] = params[:unit_ids] # For testing purpose only
		session[:semesters][1] = params[:unit_ids] # For testing purpose only

		# Get list of done units with ID integer
		params[:unit_ids].each do |puid|
			@done_units += StreamUnit.where(:stream_id => session[:selected_stream]).where(:unit_id => (puid.to_i))
		end
		
		# Get list of remaining units with done units object
		@remain_units = getRemainingUnits(@done_units)

		# Assign remaining units' IDs to session variable
		@remain_units.each do |ru|
			session[:remain_units] << ru.id
		end
	end

	def getRemainingUnits(done)
		# Get StreamUnit where SUs are in "selected stream", and ID is not in "done"
		remain_streamunits = StreamUnit.where(:stream_id => session[:selected_stream]).where('id not in (?)', done)
		return remain_streamunits
	end

	def get_done_unit_semester uid
		# which semester did the unit being done?
	end
# END enrolment_planner

end

# START AJAX Testing
def ajaxTesting
		render :text => "Success"
end