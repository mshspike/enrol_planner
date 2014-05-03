class PlannerController < ApplicationController
	def index
		@streamlist = Stream.all 	# Retrieves list of courses from Model
	end

	def units_chooser
		@selectStream = Stream.find(params["streamSelect"])
		@stream_units = getStreamUnits(@selectStream)
	end

	def getStreamUnits(chosen_course)
		@unitlistindex = StreamUnit.where(stream_id: chosen_course)

		@unitlist = Unit.where(id: @unitlistindex)
		return @unitlist

	end
end
