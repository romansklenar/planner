class TasksController < ApplicationController
  before_filter :require_user
  before_filter :load_collection, :only => ['index', 'new', 'create']
  before_filter :load_object,     :only => ['show', 'edit', 'update', 'destroy']


private

  def load_collection
    unless params[:project_id].blank?
      @tasks = current_user.projects.find(params[:project_id]).tasks
    else
      @tasks = current_user.tasks.find(:all)
    end
  end

  def load_object
    @task = current_user.tasks.find(params[:id])
  end

public

  def new
    @task = @tasks.new #(:project_id => params[:project_id])
  end
  
  def create
    @task = @tasks.new(params[:task])
    if @task.save
      flash[:notice] = "Successfully created task."
      redirect_to @task.project
    else
      render :action => 'new'
    end
  end
  
  def edit
    render
  end
  
  def update
    if @task.update_attributes(params[:task])
      flash[:notice] = "Successfully updated task."
      redirect_to @task.project
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @task.destroy
    flash[:notice] = "Successfully destroyed task."
    redirect_to @task.project
  end
end
