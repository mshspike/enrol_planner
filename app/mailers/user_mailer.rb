class UserMailer < ActionMailer::Base
  default from: 'enrolplanner@gmail.com'
  
	def send_sp(recipient)
		@email = recipient
		mail(to: @email, subject: 'Study Plan From Enrolment Planner ') 
		attachments["StudyPlan.pdf"] = SemboxPdf.new(view_context).render

	end
end