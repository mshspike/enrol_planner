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
                prereq_code_list.push(pr.preUnit_code.to_i)
            end
        end
        return prereq_code_list.uniq
    end

    def get_uid_by_unitCode ucode
        return Unit.where(:unitCode => ucode.to_i).first.id
    end

    def has_done_prereq plan_units, done_units, uid
        # Get all pre-req groups with given uid
        prereq_groups_id = PreReqGroup.where(:unit_id => uid.to_i)
        
        # If has group
        unless prereq_groups_id.empty?
            prereq_groups_id.each do |prgroup_id|
                if has_done_prereq_by_group(plan_units, done_units, prgroup_id.id)
                    return true
                end
            end
            return false
        else
            return true
        end
    end

    def has_done_prereq_by_group plan_units, done_units, gid
        prereqs = PreReq.where(:pre_req_group_id => gid.to_i)
        prereqs.each do |pr|
            unless has_done_by_code(plan_units, done_units, pr.preUnit_code.to_i)
                return false
            end
        end
        return true
    end

    def has_done_by_code plan_units, done_units, ucode
        u = Unit.where(:unitCode => ucode.to_i)
        if (plan_units.include? u.first.id) || (done_units.include? u.first.id)
            return true
        else
            return false
        end
    end
end
