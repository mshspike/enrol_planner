class PlannerController < ApplicationController
	#@selected_stream
	@stream_units

	before_filter :get_selected_stream

	helper_method :get_streamunit_name

# START stream_chooser
	def index
		@streams = Stream.all
	end
# END stream_chooser


# START unit_chooser
	def unit_chooser
		@selected_stream = Stream.find_by_id(params["streamSelect"])

		#declare session variable and store selected stream id to it
		(session[:select_stream] ||= []) && (session[:select_stream] = @selected_stream.id )
		@stream_units = getStreamUnits(@selected_stream)
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

		params[:unit_ids].each do |puid|
			@done_units += StreamUnit.where(:stream_id => session[:select_stream]).where(:unit_id => (puid.to_i))
		end
		
		@remain_units = getRemainingUnits(@done_units)
	end

	def getRemainingUnits(done)			
		remain_streamunits = StreamUnit.where(:stream_id => session[:select_stream]).where('id not in (?)', done)
		return remain_streamunits
	end
# END enrolment_planner
	def get_selected_stream
		return @selected
	end
end
