class PlannerController < ApplicationController
	def index
		@courselist = Course.all
	end

	def units_chooser
		@course_units = getCourseUnits(params["streamSelect"])
	end

	def getCourseUnits(chosen_course)
		# Awaiting for full DB structure...
		#@courseUnitsList = Streamunits.where()

		#return @courseUnitsList
	end
end
