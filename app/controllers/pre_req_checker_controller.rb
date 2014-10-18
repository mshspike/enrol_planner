class PreReqCheckerController < ApplicationController
    
    def index
        
    end

    def show
        # ActiveRecord object of the Unit
        @unit = Unit.where(:id => params[:id].to_i).first

        # has_done_prereq() returns true if all pre-requisite units are done.
        # The method is located at helpers/units_helper.rb
        @has_done = view_context.has_done_prereq(session[:done_units], session[:semesters], session[:semesters].length-1, params['id'].to_i)
    end

    
end
