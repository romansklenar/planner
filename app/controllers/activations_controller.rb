class ActivationsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :load_user_using_perishable_token, :only => [:new, :create]
  
  def new
    render
  end

  def create
    raise Exception, "User identifier and activation token do not match" unless @user == User.find(params[:id])

    if @user.activate!
      @user.deliver_activation_confirmation!
      flash[:notice] = "Your account has been activated."
      redirect_to account_url
    else
      render :action => :new
    end
  end


  private
    def load_user_using_perishable_token
      @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception, "Activation token expired")
      raise Exception, "User already activated" if @user.active?
    end

end
