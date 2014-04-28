class PlannerController < ApplicationController
	def index
		@courselist = Course.all
	end
end
