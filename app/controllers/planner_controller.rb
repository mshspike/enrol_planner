class PlannerController < ApplicationController
	def index
		@streamlist = Stream.all 	# Retrieves list of courses from Model
	end

	def units_chooser
		#@stream_units = getCourseUnits(params["streamSelect"])
	end

	def getStreamUnits(chosen_course)
		# Awaiting for full DB structure...

	end
end
