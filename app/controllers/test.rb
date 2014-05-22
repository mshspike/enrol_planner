require 'prawn'
  	Prawn::Document.generate("../../private/test_prawn.pdf") do |pdf|
  		pdf.font "Courier"

  		pdf.move_down(100)
  		pdf.draw_text("Hello Class", :at => [0, pdf.y])
  	end