class PlannerController < ApplicationController
    @stream_units
    helper_method :calc_credits, :calc_sem_credits
    include PlannerHelper

    require "unit_module.rb"

	def show
		@pdfArrPerSem = Array.new
		@pdfArrPerUnit = Array.new
		@pdf3dArr = Array.new
		@perU = Array.new
		@sembox = session[:semesters]
		@year = 1
		@a = session[:semesters][0][0]

		@sembox.each_with_index {|sem,index|
		# Start from Semester 1
			if (@a > -1)
			
				if  (@j == 2)
					@pdfArrPerUnit.push(["Year" + @year.to_s, "Semester"+ @j.to_s])
					sem.each_with_index  do |unit,index|
			
						@uName = view_context.get_unit_name(unit.to_i)
						@uCode = view_context.get_unit_code(unit.to_i)
						@pdfArrPerUnit.push([@uCode,@uName])
				
					end
					@pdfArrPerUnit.push([" " , " "])
					@j -= 1
					@year += 1
					
				else
					@j = 1
					@pdfArrPerUnit.push(["Year" + @year.to_s, "Semester"+ @j.to_s])
					sem.each_with_index  do |unit,index|
			
						@uName = view_context.get_unit_name(unit.to_i)
						@uCode = view_context.get_unit_code(unit.to_i)
						@pdfArrPerUnit.push([@uCode,@uName])
				
					end
					@pdfArrPerUnit.push([" " , " "])
					@j += 1
				end
		# Start from Semester 2	
			else
			#This is to get rid of the first -1 in the array
				sem.each_with_index  do |unit,index|
			
						unless (unit < 0)
							@uName = view_context.get_unit_name(unit.to_i)
							@uCode = view_context.get_unit_code(unit.to_i)
							@pdfArrPerUnit.push([@uCode,@uName])
						end
				
				end
			##### UNTIL HERE
			@a = 0
			@j = 2
		end

		}

		@pdfArrPerSem.push(@pdfArrPerUnit)
		@pdf3dArr.push(@pdfArrPerSem)
		
		
		time = Time.now.strftime('%Y%m%d%H%M%S')
		filename = "CoursePlan_" + time
		respond_to do |format|
			format.html
			format.pdf do
			pdf = SemboxPdf.new(@pdf3dArr)
        send_data pdf.render, :disposition => "attachment; filename=#{filename}.pdf", type: 'application/pdf', :page_size => "A4"

			end
		end        
    end
# START stream_chooser
    def index
        @streams = Stream.all

        if @streams.empty?
            @proceed = false
        else
            @proceed = true
        end

        # Clear all session variables to avoid messing with previous data
        clear_enrolment_planner_session
    end

# END stream_chooser


# START unit_chooser
    def unit_chooser
        if params[:streamSelect].nil? || params[:streamSelect] == 0
            session[:selected_stream] = 0
            @proceed = false
        else
            session[:selected_stream] = params[:streamSelect].to_i
            @proceed = true
        end

        # Pass the selected maths subject to session variable
        unless (params["maths"].nil?)
            session[:maths] = params["maths"].last
            if (session[:maths] == "2cd")
                # Replace 2 electives with MATH135 and MATH136
            elsif (session[:maths] == "3ab")
                # Replace 1 elective with MATH135
            elsif (session[:maths] == "3cd")
                # Remain the same (MATH103)
            end
        else
            session[:maths] = false
        end

        if (@proceed)
            # Get the full list of units of selected stream
            @stream_units = StreamUnit.where(:stream_id => session[:selected_stream].to_i)
            if (@stream_units.empty?)
                @proceed = false
            end

            # Put the list into array of StreamUnits, seperated by planned year and semester
            @su_y1s1 = @stream_units.where(:plannedYear => 1).where(:plannedSemester =>1)
            @su_y1s2 = @stream_units.where(:plannedYear => 1).where(:plannedSemester =>2)
            @su_y2s1 = @stream_units.where(:plannedYear => 2).where(:plannedSemester =>1)
            @su_y2s2 = @stream_units.where(:plannedYear => 2).where(:plannedSemester =>2)
            @su_y3s1 = @stream_units.where(:plannedYear => 3).where(:plannedSemester =>1)
            @su_y3s2 = @stream_units.where(:plannedYear => 3).where(:plannedSemester =>2)
        end
    end
# END unit_chooser


# START enrolment_planner
    def enrolment_planner
        # Initialising session variables. Don't use "Array.new" to initialize here, 
        # as it will erase everything when the page is refreshed.
        session[:done_units]   ||= []
        session[:remain_units] ||= []
        session[:plan_units]   ||= []

        # Caching units ActiveRecord object for rendering purpose.
        suid = StreamUnit.where(:stream_id => session[:selected_stream]).pluck(:unit_id)
        @units = Unit.where(:id => suid)

        @proceed = true

        if request.get?()
            return
        end

        if params[:modflag].to_i != 0
            session[:enrol_planner_flag] = params[:modflag].to_i
        end


        # Deciding actions with given control flag. There are five defined actions:
        # 1. Default action
        # 2. Add units action
        # 3. Remove units action
        # 4. Finalize semester action
        # 5. Modify previous semester action
        # 6. Automated enrolment planning
        case session[:enrol_planner_flag]
            # Action #1 - Default action
            when 1
                if params.has_key?(:unit_ids)
                    params[:unit_ids].each do |doneid|
                        unless session[:done_units].include? doneid.to_i
                            session[:done_units].push(doneid.to_i)
                        end
                    end
                end

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
                
                # Get list of remaining units with done units object
                session[:remain_units] = get_remaining_units(session[:done_units])

            # Action #2 - Add units action
            when 2
                # Validation - proceed if:
                # 1. Input parameter is not empty
                # 2. No duplication in destination
                # 3. Available for current semester
                # 4. Semester is not in full credit
                # 5. Units has all pre-requisite done
                
                # Validation #1 - If param is not nil - Pass
                unless params[:remain_unit].nil?
                    params[:remain_unit].each do |pru|
                        lastsem_index = session[:semesters].length-1
                        @proceed = false

                        # Validation #2 - No duplication - Pass
                        unless session[:semesters][lastsem_index].include? pru.to_i
                            # Validation #3 - Available for current semester - Pass
                            if is_avail_for_sem(lastsem_index, pru.to_i)
                                # Validation #4 - Semester is not in full credit - Pass
                                if sem_is_not_full(lastsem_index, pru.to_i)
                                    # Validation #5 - Unit has all pre-requisite done - Pass
                                    if view_context.has_done_prereq(session[:done_units], session[:semesters], lastsem_index, pru.to_i)
                                        @proceed = true
                                    # Validation #5 - Unit has all pre-requisite done - Fail
                                    else
                                        @proceed = false
                                        @msg = "You have not done pre-requisite units for " + \
                                                view_context.get_unit_name(pru) + "!"
                                    end
                                #Validation #4 - Semester is not in full credit - Fail
                                else
                                    @proceed = false
                                    @msg = "Semester is in full credit!"
                                end
                            # Validation #3 - Avaiable of current semester - Fail
                            else
                                @proceed = false
                                @msg = view_context.get_unit_name(pru) + " is not avilable for this semester!"
                                puts "****** Unit not available for current semester. uid = " + pru.to_s \
                                     + " , semAvail = " + view_context.get_unit_semavailable(pru).to_s + " , cur_sem = " + lastsem_index.to_s
                            end
                        # Validation #2 - No duplication - Fail
                        else
                            @proceed = false
                            @msg = "Duplicated units in current semester."
                        end

                        # If passes all Validations, start adding unit to semester.
                        if (@proceed)
                            # Add unit id to semester and planned unit list.
                            session[:plan_units].push(pru.to_i)
                            if (session[:semesters][lastsem_index][0] != 0)
                                session[:semesters][lastsem_index].push(pru.to_i)
                            else
                                session[:semesters][lastsem_index][0] = pru.to_i
                            end

                            # Remove unit id from remaining unit list
                            session[:remain_units].slice!(session[:remain_units].index(pru.to_i))
                        end
                    end
                # Validation #1 - If param is not nil - Fail
                else
                    @proceed = false
                    @msg = "You have not select any unit!"
                end

            # Action #3 - Remove units actions
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

            # Action #4 - Finalize semester action
            when 4
                @proceed = false
                
                # Validation - proceed if:
                #  1. remaining units list is not empty
                if (session[:remain_units].empty?)
                    @msg = "You do not have any more units left!"
                else
                    @proceed = true
                end
                
                if (@proceed)
                    new_sem(session[:semesters].length-1)
                end

            # Action #5 - Modify previous semester action
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

            # Action #6 - Automated enrolment planning (new semester)
            when 6
                if (params[:include_planned].nil?)    # New semester
                    if (session[:semesters].last.empty?)
                        auto_planning(session[:semesters].length-1)
                    else
                        new_sem_index = new_sem(session[:semesters].length-1)
                        auto_planning(new_sem_index)
                    end
                else    # Include planned semester
                    if (session[:semesters][0][0] == -1)
                        auto_planning(1)
                    else
                        auto_planning(0)
                    end
                end                
        end

        # Print out session variables to console.
        debug_print_session
    end
# END enrolment_planner

	def validate
		unless params[:semesters].nil?
			# update session with posted data
			session[:semesters] = JSON.parse(params[:semesters])
			session[:plan_units] = session[:semesters].flatten
			session[:remain_units] = JSON.parse(params[:remain_units])
			#validate_all
			@invalid_units = []
			plan_units_so_far = []
			session[:semesters].each_with_index do |semester, semId|
				sem = (semId%2)+1
				semester.each do |uid|
					unless (uid == -1)
						unless view_context.has_done_prereq(session[:done_units], session[:semesters], semId, uid.to_i) and is_avail_for_sem(semId, uid)
							@invalid_units.push(uid)
						end
					end
				end
				plan_units_so_far.concat semester
			end
			@valid = true
			if not @invalid_units.empty?
				@valid = false
			end
			# Print out session variables to console.
			debug_print_session
			print "    invalid_units: "
			puts "[" + @invalid_units.join(',') + "]"
		end
	end
	
	def debug_print_session
		# Print out session variables to console.
        puts "Session variables:"
        print "    selected_stream: "
		puts session[:selected_stream]
        print "    enrol_planner_flag: "
		puts session[:enrol_planner_flag]
        print "    done_units: "
		puts "[" + session[:done_units].join(',') + "]"
        print "    remain_units: "
		puts "[" + session[:remain_units].join(',') + "]"
        print "    plan_units: "
		puts "[" + session[:plan_units].join(',') + "]"
        print "    semesters: "
            session[:semesters].each do |sem|
                print "[" + sem.join(',') + "],"
            end
            puts ""
    end

    # Auto-planning method triggered by auto-plan sub-action (control flag = 6).
    # Params:
    # +sem_index+:: Latest semester's index in session variable
    def auto_planning sem_index

        # Preparing units tacks
        #  sem_units[0]:: Stack of units available for semester 1 
        #  sem_units[1]:: Stack of units available for semester 2
        #  sem_units[2]:: Stack of units available for all semester and flexible units such as electives and SEP
        sem_units = Array.new(3)

        sem0_units = Unit.where(:semAvailable => 0).pluck(:id)
        sem_units[0] = StreamUnit.where(:stream_id => session[:selected_stream]).where(:unit_id => session[:remain_units]) \
                                 .where(:unit_id => sem0_units).order(:plannedYear).pluck(:unit_id)
        sem_units[1] = StreamUnit.where(:stream_id => session[:selected_stream]).where(:unit_id => session[:remain_units]) \
                                 .where(:plannedSemester => 1).order(:plannedYear).pluck(:unit_id)
        sem_units[2] = StreamUnit.where(:stream_id => session[:selected_stream]).where(:unit_id => session[:remain_units]) \
                                 .where(:plannedSemester => 2).order(:plannedYear).pluck(:unit_id)

        # Delete extra elective units to match remaining units list.
        while (sem_units[0].count(1) > session[:remain_units].count(1))
            sem_units[0].delete_at(sem_units[0].index(1))
            if (sem_units[1].include? 1)
                sem_units[1].delete_at(sem_units[1].index(1))
            else
                sem_units[2].delete_at(sem_units[2].index(1))
            end
        end

        puts "sem_units[0] = [" + sem_units[0].join(',') + "]"
        puts "sem_units[1] = [" + sem_units[1].join(',') + "]"
        puts "sem_units[2] = [" + sem_units[2].join(',') + "]"
        
        # Stops when remaining units list is empty
        while (!session[:remain_units].blank?)
            # Determining Semester 1 or Semester 2
            if (sem_index % 2 == 0)    # Semester 1
                scan_sem_stack(sem_units, 1, sem_index)
                scan_sem_stack(sem_units, 0, sem_index)
            else    # Semester 2
                scan_sem_stack(sem_units, 2, sem_index)
                scan_sem_stack(sem_units, 0, sem_index)
            end
            sem_index = new_sem(sem_index)
        end
    end

    def scan_sem_stack sem_units, sem, sem_index
        aryDel = Array.new

        sem_units[sem].each do |uid|
            if (sem_is_not_full(sem_index, uid))
                if (view_context.has_done_prereq(session[:done_units], session[:semesters], sem_index, uid))
                    add_to_sem(sem_index, uid)
                    aryDel.push(uid)
                end
            end
        end
        delete_from_sem_stacks(sem_units, aryDel)
    end

    def add_to_sem sem_index, uid
        debug_print_session
        puts "****** Adding to sem... sem_index=" + sem_index.to_s + " , uid=" + uid.to_s
        if (session[:semesters][sem_index][0] == 0)
            session[:semesters][sem_index][0] = uid.to_i
        else
            session[:semesters][sem_index].push(uid.to_i)
        end
        session[:plan_units].push(uid.to_i)
        
        session[:remain_units].slice!(session[:remain_units].index(uid))
    end

    def delete_from_sem_stacks sem_units, uids
        sem_units.each do |sem_stack|
            uids.each do |uid|
                if (sem_stack.include? uid)
                    sem_stack.slice!(sem_stack.index(uid))
                end
            end
        end
    end

    def new_sem cur_sem_index
        new_sem_index = cur_sem_index + 1
        if (session[:semesters][new_sem_index].nil?)
            session[:semesters][new_sem_index] ||= []
            session[:semesters][new_sem_index][0] = 0
        end
        return new_sem_index
    end

    # Return remaining units' ActiveRecord array based on done units. The returning array
    # will be sorted by plannedYear and plannedSemester.
    # Params:
    # +done+:: Array of done units. Note that the array may be empty,
    #          make sure to empty-check first before accessing.
    def get_remaining_units done
        su = StreamUnit.where(:stream_id => session[:selected_stream]) \
                       .order(:plannedYear, :plannedSemester).pluck(:unit_id)

        done.each do |duid|
            su.slice!(su.index(duid))
        end

        return su
    end

    def sem_is_not_full sem_index, uid
        if (calc_sem_credits(sem_index) + view_context.get_unit_creditpoints(uid.to_i) <= 100)
            return true
        else
            return false
        end
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
                sum += view_context.get_unit_creditpoints(u.to_i)
            end
        else
            sum = 0
        end

        return sum
    end

    def calc_sem_credits sem_index
        sum = 0
        if session[:semesters][sem_index][0] != 0
            session[:semesters][sem_index].each do |sem_unit_id|
                sum += view_context.get_unit_creditpoints(sem_unit_id)
            end
        end
        return sum
    end

    def is_avail_for_sem sem_index, uid
        u = Unit.where(:id => uid.to_i).first

        if (u.semAvailable == 0)
            return true
        elsif (u.semAvailable == 1)
            if ((sem_index+1)%2 == 1)
                return true
            else
                return false
            end
        elsif (u.semAvailable == 2)
            if ((sem_index+1)%2 == 0)
                return true
            else
                return false
            end
        else
            return false
        end
    end
	
	def send_email 
			@email = params[:RecipientEmail]
			UserMailer.send_sp(@email).deliver 
	end
end
