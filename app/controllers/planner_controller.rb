class PlannerController < ApplicationController
	@selected_stream
	@stream_units

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
		done_units = []
		done_units_id = params[:unit][:id]

		done_units_id.keys.each do |key|
			done_units += Unit.where(:id => done_units_id[key].to_i)
		end
		
		@remain_units = getRemainingUnits(done_units)
	end

	def getRemainingUnits(done)
		remain_streamunits = StreamUnit.where('id not in (?)', done)
		remain_units = Unit.where(:id => remain_streamunits)
		return remain_units
	end
# END enrolment_planner
end
