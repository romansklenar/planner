class UserSessionsController < ApplicationController
  before_filter :login_required, :except => [:new, :create]

  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Logged in successfully."
      redirect_back_or_default(root_url)
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "You have been logged out."
    redirect_to root_url
  end
end
