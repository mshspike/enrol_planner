class StreamUnitsController < ApplicationController
  before_action :set_stream_unit, only: [:show, :edit, :update, :destroy]

  # GET /stream_units
  # GET /stream_units.json
  def index
    @stream_units = StreamUnit.all
    time = Time.now.strftime('%Y%m%d%H%M%S')
    filename = "CoursePlan_" + time
    respond_to do |format|
      format.html
      format.csv { send_data @stream_unit_names.to_csv, :disposition => "attachment;filename=#{filename}.csv" }
      format.pdf do
        pdf = StreamUnitPdf.new(@stream_unit_names)
        send_data pdf.render, :disposition => "attachment;filename=#{filename}.pdf", type: 'application/pdf', :page_size => "A4"
      end
    end
  end


  # GET /stream_units/1
  # GET /stream_units/1.json
  def show
  end

  # GET /stream_units/new
  def new
    @stream_unit = StreamUnit.new
  end

  # GET /stream_units/1/edit
  def edit
  end

  # POST /stream_units
  # POST /stream_units.json
  def create
    @stream_unit = StreamUnit.new(stream_unit_params)

    respond_to do |format|
      if @stream_unit.save
        format.html { redirect_to @stream_unit, notice: 'Stream unit was successfully created.' }
        format.json { render action: 'show', status: :created, location: @stream_unit }
      else
        format.html { render action: 'new' }
        format.json { render json: @stream_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stream_units/1
  # PATCH/PUT /stream_units/1.json
  def update
    respond_to do |format|
      if @stream_unit.update(stream_unit_params)
        format.html { redirect_to @stream_unit, notice: 'Stream unit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @stream_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stream_units/1
  # DELETE /stream_units/1.json
  def destroy
    @stream_unit.destroy
    respond_to do |format|
      format.html { redirect_to stream_units_url }
      format.json { head :no_content }
    end
  end

  # START importing stream_units from CSV
  def import
    StreamUnit.import(params[:file])
    redirect_to stream_units_path, notice: 'Course Plan Updated Successfully'     
  end
  # END importing stream_units from CSV

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stream_unit
      @stream_unit = StreamUnit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stream_unit_params
      params.require(:stream_unit).permit(:stream_id, :unit_id)
    end
end
