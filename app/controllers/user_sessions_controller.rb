class UserSessionsController < ApplicationController
skip_before_filter :require_login, except: [:destroy]
  def new
	@user = User.new
  end

  def create
	if @user = login(params[:email], params[:password])
      redirect_back_or_to(:users, notice: 'Login successful')
    else
      flash.now[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    logout
	respond_to do |format|
    format.html{redirect_to(planner_index_path, notice: 'Logged out!')}
	format.json { head :no_content }
	end
	end
end
