class UserMailer < ActionMailer::Base
  default from: 'enrolplanner@gmail.com'
  
	def send_sp(recipient, pdf)
		@email = recipient
		@pdf  = pdf
		report_pdf_view = SemboxPdf.new(@pdf)
		report_pdf_content = report_pdf_view.render()
		mail(to: @email, subject: 'Study Plan From Enrolment Planner ') 
		attachments["StudyPlan.pdf"] = { mime_type: 'application/pdf', content: report_pdf_content}

	end
end
