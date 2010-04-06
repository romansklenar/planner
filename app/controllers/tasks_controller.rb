class TasksController < ApplicationController
  before_filter :require_user
  before_filter :load_collection, :only => ['index', 'new', 'create']
  before_filter :load_object,     :only => ['show', 'edit', 'update', 'destroy', 'toggle']


private

  def load_collection
    unless params[:project_id].blank?
      @tasks = current_user.projects.find(params[:project_id]).tasks
    else
      @tasks = current_user.tasks.incomplete
    end
  end

  def load_object
    @task = current_user.tasks.find(params[:id].to_i)
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

  # Sorts task inside project
  def sort
    params[:tasks].each_with_index do |id, index|
      Task.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end

  # Toggles between completed and uncompleted states
  def toggle
    if @task.toggle! :completed
      flash[:notice] = (@task.completed?) ? 'Task was completed' : 'Task was opened again' unless request.xhr?
    end
    respond_to do |format|
      format.html { redirect_to projects_path }
      format.js do
        render :update do |page|
          page.replace dom_id(@task), :partial => 'task', :object => @task
          page.visual_effect :highlight, dom_id(@task), :duration => 1.5, :delay => 0.3
        end
      end
    end
  end
end
