class ProjectsController < ApplicationController
  before_filter :require_user
  before_filter :load_collection, :only => ['index', 'new', 'create']
  before_filter :load_object,     :only => ['show', 'edit', 'update', 'destroy', 'archive', 'restore', 'accept']


private

  def load_collection
    @projects = current_user.projects
    @archived_projects = current_user.archived_projects
  end

  def load_object
    if current_user.projects.exists? params[:id].to_i
      @project = current_user.projects.find(params[:id].to_i)
    else
      @project = current_user.archived_projects.find(params[:id].to_i)
    end
  end

  def apply_search(collection)
    collection = collection.all(:conditions => ["name LIKE ?", "%#{params[:search]}%"]) if params.has_key?(:search)
    return collection
  end

public

  def index
    @projects = apply_search(@projects)
    @archived_projects = apply_search(@archived_projects)
    render
  end
  
  def show
    respond_to do |format|
      format.html
      format.ics do
        cal = @project.to_calendar
        cal.publish
        render :text => cal.to_ical
      end
    end
  end
  
  def new
    @project = @projects.new
  end
  
  def create
    @project = @projects.new(params[:project])
    if @project.save
      flash[:notice] = "Successfully created project."
      redirect_to @project
    else
      render :action => 'new'
    end
  end
  
  def edit
    render
  end
  
  def update
    if @project.update_attributes(params[:project])
      flash[:notice] = "Successfully updated project."
      redirect_to @project
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @project.destroy!
    flash[:notice] = "Successfully destroyed project."
    redirect_to projects_url
  end

  def archive
    @project.archive
    flash[:notice] = "Successfully archived project."
    redirect_to projects_url
  end

  def restore
    Project.restore(params[:id].to_i)
    flash[:notice] = "Successfully restored project from archive."
    redirect_to projects_url
  end

  # allows dragging tasks to project
  def accept
    task = model_from_dom_id(params[:draggable_element])
    old_project = task.project
    @project.tasks.push(task) unless @project.tasks.exists?(task)
    flash[:notice] = "Task #{task.name} successfully moved to project #{@project.name}" unless request.xhr?

    respond_to do |format|
      format.html { redirect_to projects_path }
      format.js do
        render :update do |page|
          page.visual_effect :highlight, dom_id(task), :duration => 1.5, :delay => 0.3
        end
      end
    end
  end
end
