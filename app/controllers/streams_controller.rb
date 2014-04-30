class streamsController < ApplicationController
	# before_action :set_stream, only: [:show, :edit, :update, :destory]

	# GET /streams
	# GET /streams.json
	def index
		@streams = stream.all
	end
	
	# GET /streams/id#
	# GET /streams/id#.json
	def show
		
	end
	
	# GET /streams/new
	def new
		@stream = stream.new
	end
	
	# GET /streams/id#/edit
	def edit # create "edit" form here, then pass to update action
		
	end
	
	# POST /streams
	# POST /streams.json
	def create
		@stream = stream.new(stream_params)

		respond_to do |format|
			if @stream.save
				
			else
				
			end
		end
	end
	
	def update
		respond_to do |format|
			if @stream.update(stream_params) # if update successful
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
		def set_stream
			@stream = stream.find(params[:id])
			# @stream = stream.find(params[:streamCode])
		end

		def post_params
			params.require(:stream).permit(:streamName)
		end

end
