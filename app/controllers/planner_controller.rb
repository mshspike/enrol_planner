class PlannerController < ApplicationController
	@stream_units
	helper_method :get_streamunit_name, :get_unit_credit_points, :get_unit_sem_available, :get_stream_name, :calc_credits, :get_unit_code, :get_has_prereq

	def show
		
	end

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
		unless params["streamSelect"].nil?
			session[:selected_stream] = params["streamSelect"]
		end

		str = Stream.find(session[:selected_stream])
		@stream_units = StreamUnit.where(:stream_id => str)
	end

	def get_streamunit_name uid
		u = Unit.find_by_id(uid.to_i)
		return u.unitName
	end
	
	def get_unit_sem_available u
		@unit = Unit.find(u.to_i)
		#@unit = Unit.where(id: u.to_i)
		return @unit.semAvailable
	end
	
	def get_unit_code u
		@unit = Unit.find(u.to_i)
		#@unit = Unit.where(id: u.to_i)
		return @unit.unitCode
	end

# END unit_chooser


# START enrolment_planner
	def enrolment_planner
		# don't use "Array.new" to initialize here.
		# this will erase everything when the page is refreshed.
		session[:done_units] ||= []
		session[:plan_units] ||= []
		@proceed = true

		if params[:modflag].to_i != 0
			session[:enrol_planner_flag] = params[:modflag].to_i
		end

		case session[:enrol_planner_flag]
			# Default action from "unit_chooser"
			when 1
				@done_units = []
				
				if params.has_key?(:unit_ids)
					params[:unit_ids].each do |doneid|
						unless session[:done_units].include? doneid.to_i
							session[:done_units].push(doneid.to_i)
						end
					end
				end

				# INITIALISE remain_units session variable
				session.delete(:remain_units)
				session[:remain_units] ||= []

				# START initialising session[:semesters]
				session[:semesters]=[]
				session[:semesters][0] = []
				session[:semesters][0][0] = 0
				# if start at sem 2
        		if (params[:sem].to_i == 2)
					session[:semesters].push([0])
					session[:semesters][0][0] = -1
				end
				# END initialising

				# Get list of done units with ID integer
				unless params[:unit_ids].nil?
					params[:unit_ids].each do |puid|
						@done_units += StreamUnit.where(:stream_id => session[:selected_stream]) \
												 .where(:unit_id => (puid.to_i))
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
				session[:remain_units].sort!

			# Add chosen units to "plan_units" from "remaining units"
			when 2
				#@proceed = false
				
				# Validation - proceed if:
				#  1. semester is not in full credit
				#  2. available for current semester
				#  3. No Duplicated units in semester (prevent page refresh)
				#  4. Done pre-requisites
				unless params[:remain_unit].nil?
					params[:remain_unit].each do |pru|
						@proceed = false
						if (!has_prereq(pru))
							if (is_avail_for_sem(session[:semesters].length, pru))
								if (session[:semesters].last.last == 0)
									@proceed = true
								else
									# check if semester still has capacity for enrol in more credit points
									if (session[:semesters].last.length <= 4)	
										if (calc_sem_credits((session[:semesters].length)-1) <= (100.0-get_unit_credit_points(pru)))	
											params[:remain_unit].each do |remain|
												unless session[:semesters].last.include? remain.to_i
													@proceed = true
												else
													@msg = "Duplicated Unit."
												end
											end
										else
											@msg = "Credit points full!"
										end
									end
								end
							else
								@proceed = false
								@msg = get_streamunit_name(pru.to_i).to_s + " is not available for this semester!"
							end
						else	#check pre-requisite
							prereq_list = get_prereq_list(pru)
							isAllDone = false

							prereq_list.each_with_index do |preq, index|
								if index == 0
									if (has_done(preq.preUnit_id))
										isAllDone = true
									else
										isAllDone = false
									end
								else
									if (has_done(preq.preUnit_id))
										if (preq.group%2 == 1)
											isAllDone &&= true
										else
											isAllDone ||= true
										end
									else
										if (preq.group%2 == 1)
											isAllDone &&= false
										else
											isAllDone ||= false
										end
									end
								end
							end
							if (isAllDone)
								if (is_avail_for_sem(session[:semesters].length, pru))
									if (session[:semesters].last.last == 0)
										@proceed = true
									else
										# check if semester still has capacity for enrol in more credit points
										if (session[:semesters].last.length <= 4)	
											if (calc_sem_credits((session[:semesters].length)-1) <= (100-get_unit_credit_points(pru)))	
												params[:remain_unit].each do |remain|
													unless session[:semesters].last.include? remain.to_i
														@proceed = true
													else
														@msg = "Duplicated Unit."
													end
												end
											else
												@msg = "Credit points full!"
											end
										end
									end
								else
									@proceed = false
									@msg = get_streamunit_name(pru.to_i).to_s + " is not available for this semester!"
								end
							else
								@msg = "Unit " + get_streamunit_name(pru) + " has pre-requisite unit that you have not done!"
								get_prereq_list(pru).each do |preq|
									@msg = @msg + "\\n  - " + get_streamunit_name(preq.preUnit_id)
								end
							end
						end
						if @proceed
							session[:plan_units].push(pru.to_i)

							# Add unit to "semesters" session variable
							last_sem = session[:semesters].length-1
							if (session[:semesters][last_sem][0] == 0)
								session[:semesters][last_sem][0] = pru.to_i
							else
								sem = session[:semesters].last
								sem.push(pru.to_i)
							end

							# Remove unit from "remaining" list
							session[:remain_units].length.times do |i|
								if (session[:remain_units][i] == pru.to_i)
									session[:remain_units].delete_at(i)
								end
							end
						end
					end
					session[:remain_units].sort!
				else
					@msg = "No unit has been chosen."
				end

			# Delete one unit from semester.
			when 3
				@proceed = false
				
				# Validation - proceed if:
				#  1. at least one unit in current semester is selected
				#  2. not identical unit in remaining units list (prevent page refresh)
				unless params[:current_sem].nil?
					params[:current_sem].each do |cur|
						unless session[:remain_units].include? cur.to_i
							@proceed = true
						else
							@msg = "Duplicated units in remaining unit list."
						end
					end
				else
					@msg = "No remove unit selected."
				end
				
				if (@proceed)
					params[:current_sem].each do |del_id|
						session[:semesters].last.delete(del_id.to_i)
						session[:plan_units].delete(del_id.to_i)
						session[:remain_units].push(del_id.to_i)
						session[:remain_units].sort!

						if (session[:semesters].last.empty?)
							lastsem = session[:semesters].last
							lastsem[0] = 0
						end
					end
				end

			# Done semester. One new semester will be added.
			when 4
				@proceed = false
				
				# Validation - proceed if:
				#  1. remaining units list is not empty
        		#  2. semester is not empty
				unless (session[:remain_units].empty?)
					if (session[:semesters].last.last != 0)
						@proceed = true
					else
						@msg = "You have not enrol into any unit in this semester!"
					end
				else
					@msg = "You do not have any more units left!"
				end
				
				if (@proceed)
					newsem_index = session[:semesters].length # get current number of semesters
					session[:semesters][newsem_index] ||= []
					session[:semesters][newsem_index][0] = 0
				end

			# Modify previous semester
			when 5
				semid = (params[:semid].to_i)+1
				lastrow = session[:semesters].length-1

				lastrow.downto(semid) do |i|
					row = session[:semesters][i]
					unless row.nil?
						row.each do |cell|
							if (cell != 0)
								session[:plan_units].delete(cell.to_i)
								session[:remain_units].push(cell.to_i)
							end
						end
					end
					session[:semesters].delete_at(i)
				end
				session[:remain_units].sort!
		end
	end
# END enrolment_planner

	def getRemainingUnits done
		# Get StreamUnit where SUs are in "selected stream", and ID is not in "done"
		# Note that where() method returns ActiveRecord relations
		unless done.nil?
			remain_streamunits = StreamUnit.where(:stream_id => session[:selected_stream]) \
										   .where('id not in (?)', done)
		else
			remain_streamunits = StreamUnit.where(:stream_id => session[:selected_stream])
		end
		return remain_streamunits
	end

	def get_unit_credit_points uid
		@unit = Unit.find(uid.to_i)
		return @unit.creditPoints
	end

	def get_prereq_list uid
		prereqs = PreReq.where(:unit_id => uid.to_i).order(id: :asc)
		return prereqs
	end
	
	def get_has_prereq uid
		if has_prereq(uid.to_i)
			pre_req = "Y"
		else
			pre_req = "N"
		end
		return pre_req
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
				sum += get_unit_credit_points(u.to_i)
			end
		else
			sum = 0
		end

		return sum
	end

	def calc_sem_credits sem_index
		sum = 0
		session[:semesters][sem_index].each do |sem_unit_id|
			sum += get_unit_credit_points(sem_unit_id)
		end
		return sum
	end

	def is_avail_for_sem sem_id, uid
		u = Unit.find_by_id(uid.to_i)
		if (u.semAvailable%2 == sem_id%2) || (u.semAvailable == 0)
			avail = true
		else
			avail = false
		end
	end

	def has_prereq uid
		has = false
		if (Unit.find_by_id(uid.to_i).preUnit == "true")
			has = true
		end
		return has
	end

	def has_done uid
		if ((session[:done_units].include? uid.to_i) || (session[:plan_units].include? uid.to_i))
			is_done = true
		else
			is_done = false
		end
		return is_done
	end

	def is_full_credit semid
		total = 0
		if session[:semesters][semid.to_i][0] != 0
			session[:semesters][semid.to_i].each do |semunit|
				total += get_unit_credit_points(semunit.to_i)
			end
		else
			is_full = false
		end
		if total == 100
			is_full = true
		else
			is_full = false
		end
		return is_full
	end

end
