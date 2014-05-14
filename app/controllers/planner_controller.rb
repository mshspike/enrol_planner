class PlannerController < ApplicationController
	#@selected_stream
	@stream_units

	before_filter :get_selected_stream

	$testint = 1

	helper_method :get_streamunit_name

# START stream_chooser
	def index
		@streams = Stream.all
	end
# END stream_chooser


# START unit_chooser
	def unit_chooser
		@selected_stream = Stream.find_by_id(params["streamSelect"])
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
		done_units = Unit.find(params[:unit_ids])

		@testingint = @testint
		
		@remain_units = getRemainingUnits(done_units)
	end

	def getRemainingUnits(done)
		su = StreamUnit.where(:stream_id => 1) # issue here. can't get selected stream...
		remain_streamunits = Unit.where(:id => su).where('id not in (?)', done)

		#remain_streamunits = StreamUnit.where(:stream_id => @selected_stream)
		#remain_streamunits = @stream_units
		#.where(:stream_id => @selected_stream).where('unit_id not in (?)', done)
		#remain_units = Unit.where(:id => remain_streamunits)
		return remain_streamunits
	end
# END enrolment_planner
	def get_selected_stream
		return @selected
	end
end
