class PlannerController < ApplicationController
	def index
		@courselist = Course.all
	end

	def getCourseUnits
		# Awaiting for full DB structure...
		#@courseUnitsList = Streamunits.where()
	end
end
