# Helper class for Unit table
# 
# Here you can write helper methods related to Unit table. Be sure 
# when you are importing IDs, parse it to integer in case the import 
# parameter is not in integer which causes exceptions.

module UnitsHelper

    # GETTERS
    def get_unit_code uid
        return Unit.where(:id => uid.to_i).first.unitCode
    end

    def get_unit_name uid
        return Unit.where(:id => uid.to_i).first.unitName
    end

    def get_unit_semavailable uid
        u_semavail = Unit.where(:id => uid.to_i).first.semAvailable
        if (u_semavail == 0)
            return "Both"
        else
            u_semavail
        end
    end

    def get_unit_creditpoints uid
        return Unit.where(:id => uid.to_i).first.creditPoints
    end

    def get_unit_prereq_list uid
        prereq_groups = PreReqGroup.where(:unit_id => uid.to_i)

        prereq_list ||= []

        pre_req_group.each do |prg|
            prereq = PreReq.where(:prereq_groups_id => prg.id.to_i)
            
            prereq.each do |pr|
                prereq_code_list.push(pr.preUnit_code)
            end
        end
        return prereq_code_list.uniq
    end

    def get_uid_by_unitCode ucode
        return Unit.where(:unitCode => ucode).first.id
    end

    def has_done_prereq done_units, semesters, sem_index, uid
        has_done = false

        if (Unit.where(:id => uid.to_i).first.preUnit == "true")
            prereq_groups_id = PreReqGroup.where(:unit_id => uid.to_i)

            puts "Checking pre-req for uid=" + uid.to_s + ":"
            prereq_groups_id.each do |prgroup_id|
                if has_done_prereq_by_group(done_units, semesters, sem_index, prgroup_id.id)
                    return true
                else
                    has_done = false
                end
            end
        else
            return true
        end
        return has_done
    end

    def has_done_prereq_by_group done_units, semesters, sem_index, gid
        prereqs = PreReq.where(:pre_req_group_id => gid.to_i)
        puts "Checking group..."
        prereqs.each do |pr|
            unless has_done_by_code(done_units, semesters, sem_index, pr.preUnit_code)
                print pr.preUnit_code + "... Not done."
                return false
            end
        end
        return true
    end

    def has_done_by_code done_units, semesters, sem_index, ucode
        # Grab the UID with UnitCode
        uid = Unit.where(:unitCode => ucode).first.id.to_i
        has_done = false

        # Copy the semesters array, and delete current semester (sem_index)
        semArray = Array.new(semesters)
        semArray.delete_at(sem_index)

        # Printing console message.
        puts "done_units = [" + done_units.join(',') + "]"
        print "semester = "
        semArray.each do |sem|
            print "[" + sem.join(',') + "],"
        end
        puts ""
        print "\tuid = " + uid.to_s + " , uCode = " + ucode.to_s + ": "

        # Check if unit is in done_units
        if (done_units.include? uid)
            return true
        else
            has_done = false
        end

        # Check if unit is in any of the semesters, except current semester.
        semArray.each_with_index do |semester, i|
            if (semester.include? uid)
                return true
            else
                has_done = false
            end
        end

        return has_done
    end
end
