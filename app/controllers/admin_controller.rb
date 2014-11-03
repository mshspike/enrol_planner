class AdminController < ApplicationController
protect_from_forgery with: :exception
before_filter :require_login

  def index
  	@streams = Stream.all

  	# Clear all session variables to avoid messing with previous data
		session.delete(:selected_stream)

  end

  def unit_chooser
		@str = Stream.find(params["streamSelect"])

		#declare session variable and store selected stream id to it
		session[:selected_stream] = @str.id

		
		@stream_units = getStreamUnits(@str)
	end
	
	def not_authenticated
        flash[:type] = "warning"
        redirect_to login_path, notice: "Please login first"
  end
end
