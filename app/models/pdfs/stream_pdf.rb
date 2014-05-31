class StreamPdf < Prawn::Document  
  def initialize(streams)
    super()
    @streams = streams
    header
    text_content
    table_content
  end
 
  def header
    #This inserts an image in the pdf file and sets the size of the image
    #image "#{Rails.root}/app/assets/images/header.png", width: 530, height: 150
  end
 
  def text_content
    # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
    y_position = cursor - 50
  end
 
  def table_content
    # This makes a call to product_rows and gets back an array of data that will populate the columns and rows of a table
    # I then included some styling to include a header and make its text bold. I made the row background colors alternate between grey and white
    # Then I set the table column widths
    table unit_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      #self.column_widths = [40, 300, 200]
    end
  end
 
  def unit_rows
    [['Stream Code', 'Stream Name']] +
      @streams.map do |stream|
      [stream.streamCode, stream.streamName]
    end
  end
end