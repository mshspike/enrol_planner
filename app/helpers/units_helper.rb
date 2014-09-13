# Helper class for Unit table
# 
# Here you can write helper methods related to Unit table. Be sure 
# when you are importing IDs, parse it to integer in case the import 
# parameter is not in integer which causes exceptions.

module UnitsHelper
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
end
