class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update, :delegate]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])

    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions!
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => 'edit'
    end
  end

  def show
    @user = current_user
  end

  def delegate
    user = User.find(params[:id].to_i)
    task = model_from_dom_id(params[:draggable_element])
    task.delegated_user = user
    task.save
    flash[:notice] = "Task #{task.name} was successfully delegated to user #{user.login.capitalize}" unless request.xhr?

    respond_to do |format|
      format.html { redirect_to projects_path }
      format.js do
        render :update do |page|
          page.replace dom_id(task), :partial => 'tasks/task', :object => task
          page.visual_effect :highlight, dom_id(task), :duration => 1.5, :delay => 0.2
        end
      end
    end
  end
end
