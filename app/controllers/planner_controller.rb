class PlannerController < ApplicationController
	@stream_units

	helper_method :get_streamunit_name, :get_stream_name, :calc_credits

# START stream_chooser
	def index
		@streams = Stream.all

		# Clear all seesion variables to avoid messing with previous data
		session.delete(:selected_stream)
		session.delete(:semesters)
		session.delete(:done_units)
		session.delete(:plan_units)
		session.delete(:remain_units)
		session.delete(:enrol_planner_flag)
	end

	def get_stream_name sid
		s = Stream.find_by_id(sid)
		return s.streamName
	end

# END stream_chooser


# START unit_chooser
	def unit_chooser
		@str = Stream.find(params["streamSelect"])

		#declare session variable and store selected stream id to it
		session[:selected_stream] = @str.id

		
		@stream_units = getStreamUnits(@str)
	end

	def get_streamunit_name uid
		u = Unit.find_by_id(uid)
		return u.unitName
	end

	def getStreamUnits chosen_stream
		streamunits_list = StreamUnit.where(:stream_id => chosen_stream)
		# units_list = Unit.where(:id => streamunits_list)
		return streamunits_list
	end
# END unit_chooser


# START enrolment_planner
	def enrolment_planner
		session[:done_units] ||= []
		session[:plan_units] ||= []
		case session[:enrol_planner_flag]
		when 0
			@done_units = []
			session[:done_units] = params[:unit_ids]

			# INITIALISE remain_units session variable
			session.delete(:remain_units)
			session[:remain_units] ||= []

			# START initialising session[:semesters]
			session[:semesters]=[]
			session[:semesters][0] = []
			session[:semesters][0][0] = 0
			# END initialising

			#session[:semesters][0] = [1, 2, 3] # For testing purpose only
			#session[:semesters][1] = params[:unit_ids] # For testing purpose only
			#session[:semesters][2] = params[:unit_ids] # For testing purpose only

			# Get list of done units with ID integer
			unless params[:unit_ids].nil?
				params[:unit_ids].each do |puid|
					@done_units += StreamUnit.where(:stream_id => session[:selected_stream]).where(:unit_id => (puid.to_i))
				end
			else
				@done_units = nil
			end
			
			# Get list of remaining units with done units object
			@remain_units = getRemainingUnits(@done_units)

			# Assign remaining units' IDs to session variable
			@remain_units.each do |ru|
				session[:remain_units].push(ru.unit_id)
			end
		when 1
			proceed = false
			unless params[:remain_unit].nil?
				params[:remain_unit].each do |pru|
					# Add unit to "done" list
					if (session[:semesters].last.last == 0)
						proceed = true
					else
						if (session[:semesters].last.length <= 4)	
							if (calc_sem_credits((session[:semesters].length)-1) <= (100-get_unit_credit_points(pru)))
								proceed = true
							end
						end
					end
					if proceed
						#session[:done_units].push(pru)
						session[:plan_units].push(pru)

						# Add unit to "semesters" session variable
						if session[:semesters][0][0] == 0
							session[:semesters][0][0] = pru
						else
							sem = session[:semesters].last
							sem.push(pru)
						end

						# Remove unit from "remaining" list
						session[:remain_units].length.times do |i|
							if session[:remain_units][i] == pru.to_i
								session[:remain_units].delete_at(i)
							end
						end
					end
				end
			end
		end
	end

	def getRemainingUnits(done)
		# Get StreamUnit where SUs are in "selected stream", and ID is not in "done"
		# Note that where() method returns ActiveRecord relations
		unless done.nil?
			remain_streamunits = StreamUnit.where(:stream_id => session[:selected_stream]).where('id not in (?)', done)
		else
			remain_streamunits = StreamUnit.where(:stream_id => session[:selected_stream])
		end
		return remain_streamunits
	end

	def get_done_unit_semester uid
		# which semester did the unit being done?
	end

	def calc_credits which
		sum = 0
		case which
			when "completed"
				list = session[:done_units]
			when "planned"
				list = session[:plan_units]
			when "remaining"
				list = session[:remain_units]
		end

		unless list.nil?
			list.each do |u|
				sum += get_unit_credit_points(u)
			end
		else
			sum = 0
		end

		return sum
	end

	def calc_sem_credits sem
		sum = 0
		session[:semesters][sem-1].each do |sem_unit_id|
			sum += get_unit_credit_points(sem_unit_id)
		end
		return sum
	end

	def get_unit_credit_points u
		@unit = Unit.find(u.to_i)
		#@unit = Unit.where(id: u.to_i)
		return @unit.creditPoints
	end
# END enrolment_planner


end

# START AJAX Testing
def ajaxTesting
		render :text => "Success"
end