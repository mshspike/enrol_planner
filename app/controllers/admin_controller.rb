class AdminController < ApplicationController
  def index
  	@streams = Stream.all

  	# Clear all seesion variables to avoid messing with previous data
		session.delete(:selected_stream)

  end

  def unit_chooser
		@str = Stream.find(params["streamSelect"])

		#declare session variable and store selected stream id to it
		session[:selected_stream] = @str.id

		
		@stream_units = getStreamUnits(@str)
	end
end
