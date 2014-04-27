class UnitsController < ApplicationController
	def index
		@units = Unit.all
	end

	def show
		
	end

	def new
		@unit = Unit.new
	end

	def edit
		
	end

	def create
		@unit = Unit.new(unit_params)

		respond_to do |format|
			if @unit.save
				format.html {redirect_to @unit, notice: "Unit was successfully created."}
			else
				format.html {render action: "new"}
			end
		end
	end

	def update
		
	end

	def destory
		
	end

	private
		def set_unit
			@unit = Unit.find(params[:id])
			# @unit = Unit.find(params[:unitCode])
		end

		def unit_params
			params.require(:unit).permit(:unitName)
		end

end
