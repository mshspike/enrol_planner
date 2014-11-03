class UserSessionsController < ApplicationController
  skip_before_filter :require_login, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    unless current_user
      if @user = login(params[:email], params[:password])
        redirect_back_or_to(:users, notice: 'Login successful')
      else
        flash[:type] = "danger"
        flash[:notice] = 'Login failed'
        render action: 'new'
      end
    else
      redirect_to admin_index_path, notice: "You have already logged in!"
    end
  end

  def destroy
    logout
  	respond_to do |format|
      format.html { redirect_to(planner_index_path, notice: 'Logged out!') }
      format.json { head :no_content }
  	end
	end
end
