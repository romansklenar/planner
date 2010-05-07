class TasksController < ApplicationController
  before_filter :require_user
  before_filter :load_collection, :only => ['index', 'new', 'create']
  before_filter :load_object,     :only => ['edit', 'update', 'destroy', 'toggle', 'complete', 'trash', 'today', 'tomorrow']


private

  def load_collection
    @tasks = current_user.tasks
  end

  def load_object
    @task = current_user.tasks.find(params[:id].to_i) if params.has_key?(:id)
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
      redirect_back_or_default @task
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
    @task.toggle_completed!
    flash[:notice] = (@task.completed?) ? 'Task was completed' : 'Task was opened again' unless request.xhr?
    
    respond_to do |format|
      format.html { redirect_to projects_path }
      format.js do
        render :update do |page|
          page.replace dom_id(@task), :partial => 'task', :object => @task #, :locals => { :project => @project }
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


  def trash
    task = model_from_dom_id(params[:draggable_element])
    task.trash!
    task.save

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

  def today
    task = model_from_dom_id(params[:draggable_element])
    task.scheduled_to = Date.today
    task.save

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

  def tomorrow
    task = model_from_dom_id(params[:draggable_element])
    task.scheduled_to = Date.today + 1
    task.save

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

  def complete
    task = model_from_dom_id(params[:draggable_element])
    task.complete!
    task.save

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
