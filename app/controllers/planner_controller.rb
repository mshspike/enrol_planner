class PlannerController < ApplicationController
	# START stream_chooser
	def index
		# Retrieves list of courses from Model
		@streamlist = Stream.all  # instance variable, so that View has access
	end
	# END stream_chooser


	# START unit_chooser
	def unit_chooser
		# params["streamSelect"] = user selection from View form
		# this variable refers to the id of stream in Stream Model

		# find in Stream where id=streamSelect, and store the matching entry to @selectStream
		@selected_stream = Stream.find_by_id(params["streamSelect"])

		# call getStreamUnits() method to get list of units of chosen stream
		@stream_units = getStreamUnits(@selected_stream)
	end

	def getStreamUnits(chosen_stream)
		# find in StreamUnit where stream_id equals to the one of "chosen_course", and store the list
		# note that it uses where() method, where find() method can only be used for finding by "id" field
		@streamunit_list = StreamUnit.where(:stream_id => chosen_stream)

		#find in Unit where is instance of @streamunit_list, and store matchings in @unitlist
		@unitlist = Unit.where(:id => @streamunit_list)
		return @unitlist
	end
	# END unit_chooser


	# START enrolment_planner
	def enrolment_planner

		@testarray = ["a0","a1","a2","a3a"]

		# retrieves the list from unit_chooser View
		@paramid = params[:unit][:id]
		
		# stores list of done units, retrieved by getRemainingUnits() method
		@doneUnits
		#@doneUnits = Unit.where(id: params[:unit][:id])


		#@remainunitlist = getRemainingUnits(@doneUnits)
	end

	def getRemainingUnits(selected_stream, done)
		
	end
	# END enrolment_planner
end
