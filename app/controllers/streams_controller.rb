class StreamsController < ApplicationController
  before_action :set_stream, only: [:show, :edit, :update, :destroy]

  # GET /streams
  # GET /streams.json
  def index
    @streams = Stream.all
    time = Time.now.strftime('%Y%m%d%H%M%S')
    filename = "Streams_" + time
    respond_to do |format|
      format.html
      format.csv { send_data @streams.to_csv, :disposition => "attachment;filename=#{filename}.csv" }
      format.pdf do
        pdf = StreamPdf.new(@streams)
        send_data pdf.render, :disposition => "attachment;filename=#{filename}.pdf", type: 'application/pdf'
      end
    end
  end

  # GET /streams/1
  # GET /streams/1.json
  def show
  end

  # GET /streams/new
  def new
    @stream = Stream.new
  end

  # GET /streams/1/edit
  def edit
  end

  # POST /streams
  # POST /streams.json
  def create
    @stream = Stream.new(stream_params)

    respond_to do |format|
      if @stream.save
        format.html { redirect_to @stream, notice: 'Stream was successfully created.' }
        format.json { render action: 'show', status: :created, location: @stream }
      else
        format.html { render action: 'new' }
        format.json { render json: @stream.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /streams/1
  # PATCH/PUT /streams/1.json
  def update
    respond_to do |format|
      if @stream.update(stream_params)
        format.html { redirect_to @stream, notice: 'Stream was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @stream.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /streams/1
  # DELETE /streams/1.json
  def destroy
    @stream.destroy
    respond_to do |format|
      format.html { redirect_to streams_url }
      format.json { head :no_content }
    end
  end

  # START importing streams from CSV
  def import
    Stream.import(params[:file])
    redirect_to streams_path, notice: "Streams Updated Successfully"
  end
  # END importing streams from CSV

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stream
      @stream = Stream.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stream_params
      params.require(:stream).permit(:streamName, :streamCode)
    end
end
