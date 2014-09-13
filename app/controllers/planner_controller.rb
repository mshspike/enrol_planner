class PlannerController < ApplicationController
    @stream_units
    helper_method :calc_credits, :calc_sem_credits

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

# END stream_chooser


# START unit_chooser
    def unit_chooser
        unless params["streamSelect"].nil?
            session[:selected_stream] = params["streamSelect"].to_i
        end

        sid = Stream.where(:id => session[:selected_stream]).first
        @stream_units = StreamUnit.where(:stream_id => sid)
        @su_y1s1 = @stream_units.where(:plannedYear => 1).where(:plannedSemester =>1)
        @su_y1s2 = @stream_units.where(:plannedYear => 1).where(:plannedSemester =>2)
        @su_y2s1 = @stream_units.where(:plannedYear => 2).where(:plannedSemester =>1)
        @su_y2s2 = @stream_units.where(:plannedYear => 2).where(:plannedSemester =>2)
        @su_y3s1 = @stream_units.where(:plannedYear => 3).where(:plannedSemester =>1)
        @su_y3s2 = @stream_units.where(:plannedYear => 3).where(:plannedSemester =>2)
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
                @done_units = []
                
                if params.has_key?(:unit_ids)
                    params[:unit_ids].each do |doneid|
                        unless session[:done_units].include? doneid.to_i
                            session[:done_units].push(doneid.to_i)
                        end
                    end
                end

                # START initialization remain_units session variable
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
                @remain_units = get_remaining_units(@done_units)

                # Assign remaining units' IDs to session variable
                @remain_units.each do |ru|
                    session[:remain_units].push(ru.unit_id)
                end
                session[:remain_units].sort!

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
                            if is_avail_for_sem(lastsem_index+1, pru.to_i)
                                # Validation #4 - Semester is not in full credit - Pass
                                if sem_is_not_full(lastsem_index, pru.to_i)
                                    # Validation #5 - Unit has all pre-requisite done - Pass
                                    if has_done_prereq(pru.to_i)
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
                            session[:remain_units].delete(pru.to_i)
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

            # Action #6 - Automated enrolment planning
            when 6
                sem_index = session[:semesters].length

        end
    end
# END enrolment_planner

    def get_remaining_units done
        # Get StreamUnit where SUs are in "selected stream", and ID is not in "done".
        # Note that where() method returns ActiveRecord object, even if the result is
        # only one entry, it return an ActiveRecord array.
        unless done.nil?
            remain_streamunits = StreamUnit.where(:stream_id => session[:selected_stream]) \
                                           .where('id not in (?)', done)
        else
            remain_streamunits = StreamUnit.where(:stream_id => session[:selected_stream])
        end
        return remain_streamunits
    end

    def sem_is_not_full sem_index, uid
        if (calc_sem_credits(sem_index) + view_context.get_unit_creditpoints(uid.to_i) <= 100)
            return true
        else
            return false
        end
    end

    def has_done_prereq uid
        # Get all pre-req groups with given uid
        prereq_groups_id = PreReqGroup.where(:unit_id => uid.to_i)
        
        # If has group
        unless prereq_groups_id.empty?
            prereq_groups_id.each do |prgroup_id|
                if has_done_prereq_by_group(prgroup_id.id)
                    return true
                end
            end
            return false
        else
            return true
        end
    end

    def has_done_prereq_by_group gid
        prereqs = PreReq.where(:pre_req_group_id => gid.to_i)
        prereqs.each do |pr|
            unless has_done_by_code(pr.preUnit_code.to_i)
                return false
            end
        end
        return true
    end

    def has_done_by_code ucode
        u = Unit.where(:unitCode => ucode.to_i)
        if (session[:plan_units].include? u.first.id) || (session[:done_units].include? u.first.id)
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

    def is_avail_for_sem sem_id, uid
        u = Unit.where(:id => uid.to_i).first
        if (u.semAvailable == sem_id) || (u.semAvailable == 0)
            return true
        else
            return false
        end
    end
end
