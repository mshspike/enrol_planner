class PreReqGroupsController < ApplicationController
    def index
        @pre_req_groups = PreReqGroup.all
        
    end

    # GET /prereqgroups/1
    # GET /prereqgroups/1.json
    def show
        @pre_req_group = PreReqGroup.where(:id => params["id"].to_i).first
    end
end
