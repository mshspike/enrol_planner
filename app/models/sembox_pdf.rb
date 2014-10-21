class SemboxPdf < Prawn::Document  
  def initialize pdfArrPerSem
    super()
	@pdfArrPerSem = pdfArrPerSem
    header
    text_content
    table_content
    end_record
    footer
    page_no
  end
 
  def header
    #This inserts an image in the pdf file and sets the size of the image
    #image "#{Rails.root}/app/assets/images/header.png", width: 530, height: 150
    text "Course Planned", :size => 20
    move_down 15
  end

  def text_content
    # The cursor for inserting content starts on the top left of the page. Here we move it down a little to create more space between the text and the image inserted above
    y_position = cursor - 50

  end
 
  def table_content
    # This makes a call to product_rows and gets back an array of data that will populate the columns and rows of a table
    # I then included some styling to include a header and make its text bold. I made the row background colors alternate between grey and white
    # Then I set the table column widths

	@pdfArrPerSem.each do |unit|
			@perUnit = unit
			table sembox_rows(@perUnit) do
			row(0).font_style = :bold
			self.header = false
			self.row_colors = ['FFFFFF', 'FFFFFF']
			self.column_widths = [150, 250]
			end
	end

  end
 

  
  def sembox_rows perUnit
	move_down 15
	[['Unit Code', 'Unit Name']] +
	perUnit


  end
  def end_record
    move_down 35
    text "---------------------End of Units---------------------", :color => "6E6E6E", :align => :center
  end

  def footer
    datetime = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    string = "Created at " + datetime
    options = { :at => [bounds.left - 0, 0],
     :align => :left,
     :start_count_at => 1,
     :color => "6E6E6E" }
    number_pages string, options
  end

  def page_no
    string = "page <page> of <total>"
    options = { :at => [bounds.right - 150, 0],
     :width => 150,
     :align => :right,
     :start_count_at => 1,
     :color => "6E6E6E" }
    number_pages string, options
  end
  
end