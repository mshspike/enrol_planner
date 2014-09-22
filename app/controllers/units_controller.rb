 class UnitsController < ApplicationController
  before_action :set_unit, only: [:show, :edit, :update, :destroy]

  # GET /units
  # GET /units.json
  def index
    @units = Unit.all
    time = Time.now.strftime('%Y%m%d%H%M%S')
    filename = "Units_" + time
    respond_to do |format|
      format.html
      format.csv { send_data @units.to_csv, :disposition => "attachment;filename=#{filename}.csv" }
      format.pdf do
        pdf = UnitPdf.new(@units)
        send_data pdf.render, :disposition => "attachment;filename=#{filename}.pdf", type: 'application/pdf', :page_size => "A4"
      end
    end
  end

  # GET /units/1
  # GET /units/1.json
  def show
  end

  # GET /units/new
  def new
    @unit = Unit.new
  end

  # GET /units/1/edit
  def edit
  end

  # POST /units
  # POST /units.json
  def create
    @unit = Unit.new(unit_params)
    respond_to do |format|
      if @unit.save
        format.html { redirect_to @unit, notice: 'Unit was successfully created.' }
        format.json { render action: 'show', status: :created, location: @unit }
      else
        format.html { render action: 'new' }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    respond_to do |format|
      if @unit.update(unit_params)
        format.html { redirect_to @unit, notice: 'Unit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    @unit.destroy
    respond_to do |format|
      format.html { redirect_to units_url }
      format.json { head :no_content }
    end
  end

  # START importing units from CSV
  def import
    unless params[:file].nil?
		@valid = Unit.import(params[:file])
		if @valid = 1
		redirect_to units_path, notice: 'Unit imported Successfully'
		else
		redirect_to units_path, notice: 'Unit imported Failed'
		end
	else
		redirect_to units_path, notice: 'NO file attached'
	end
  end
  # END importing units from CSV

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_params
      params.require(:unit).permit(:unitCode, :unitName, :preUnit, :creditPoints, :semAvailable)
    end
end
