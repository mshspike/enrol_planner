class CoursesController < ApplicationController
	# before_action :set_course, only: [:show, :edit, :update, :destory]

	# GET /courses
	# GET /courses.json
	def index
		@courses = Course.all
	end
	
	# GET /courses/id#
	# GET /courses/id#.json
	def show
		
	end
	
	# GET /courses/new
	def new
		@course = Course.new
	end
	
	# GET /courses/id#/edit
	def edit # create "edit" form here, then pass to update action
		
	end
	
	# POST /courses
	# POST /courses.json
	def create
		@course = Course.new(course_params)

		respond_to do |format|
			if @course.save
				
			else
				
			end
		end
	end
	
	def update
		respond_to do |format|
			if @course.update(course_params) # if update successful
				# redirect to "update successful" page
			else # if unsuccessful
				# redirect to "update unsuccessful" page
			end
		end
	end
	
	def destory
		# respond_to action will be added later
	end

	private
		def set_course
			@course = Course.find(params[:id])
			# @course = Course.find(params[:courseCode])
		end

		def post_params
			params.require(:course).permit(:courseName)
		end

end
