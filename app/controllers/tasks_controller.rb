class TasksController < ApplicationController
  before_filter :require_user
  before_filter :load_collection, :only => ['index', 'new', 'create']
  before_filter :load_object,     :only => ['edit', 'update', 'destroy', 'toggle']


private

  def load_collection
    unless params[:project_id].blank?
      @project = current_user.projects.find(params[:project_id].to_i)
      @tasks = @project.tasks
    else
      @tasks = current_user.tasks.incomplete
    end
  end

  def load_object
    @project = current_user.projects.find(params[:project_id].to_i)
    @task = @project.tasks.find(params[:id].to_i)
  end

public

  def show
    @task = Task.find(params[:id].to_i)
  end

  def new
    @task = @tasks.new
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
    redirect_back_or_default @task.project
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
          page.replace dom_id(@task), :partial => 'task', :object => @task, :locals => { :project => @project }
          page.visual_effect :highlight, dom_id(@task), :duration => 1.5, :delay => 0.2
        end
      end
    end
  end

  # Recently completed tasks
  def recent
    @tasks = Task.recently_completed
    respond_to do |format|
      format.atom # recent.atom.builder
    end
  end
end
