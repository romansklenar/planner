class TasklistsController < ApplicationController

  def show
    store_location
    
    @tasks = case params[:list]
      when 'inbox' then current_user.inbox_list.tasks.incomplete.not_today
      when 'next-steps' then current_user.next_list.tasks.incomplete
      when 'someday' then current_user.someday_list.tasks.incomplete
      when 'today' then current_user.tasks.today.incomplete
      when 'tomorrow' then current_user.tasks.tomorrow.incomplete
      when 'scheduled' then current_user.tasks.scheduled.incomplete
      when 'delegated' then current_user.tasks.delegated.incomplete
      when 'completed' then current_user.tasks.completed
      when 'trashed' then current_user.tasks.trashed
    end

    flash[:notice] = "No tasks in tasklist #{params[:list].capitalize}" if @tasks.empty?

    filter_by_tag
    filter_by_user
    respond_to do |format|
      format.html
    end
  end



  # allows dragging tasks to project
  def accept
    task = model_from_dom_id(params[:draggable_element])
    @tasklist = current_user.tasklists.find(params[:id])

    unless @tasklist.nil?
      @tasklist.tasks.push(task) unless @tasklist.tasks.exists?(task)
      flash[:notice] = "Task #{task.name} successfully moved to tasklist #{@tasklist.name}" unless request.xhr?
    end

    respond_to do |format|
      format.html { redirect_to projects_path }
      format.js do
        render :update do |page|
          page.replace dom_id(task), :partial => 'tasks/task', :object => task
          page.visual_effect :highlight, dom_id(task), :duration => 1.5, :delay => 0.2
          page.visual_effect :fade, dom_id(task), :duration => 1.5, :delay => 0.2 unless @tasklist.nil?
        end
      end
    end
  end


  private

  def filter_by_user
    if params.has_key?(:user) and !params[:tag].blank?
      for task in @tasks
        @tasks.delete(task) unless task.delegated_user.login == params[:login]
      end
      flash[:notice] = "No tasks for user #{params[:login]}"
    end
  end

  def filter_by_tag
    if params.has_key?(:tag)
      if params[:tag] == 'none'
        remove_non_tagged_tasks
        flash[:notice] = "No untagged tasks found." if @tasks.empty?
      elsif !params[:tag].blank?
        @tasks = @tasks.tagged_with(params[:tag])
        flash[:notice] = "No tasks for tag #{params[:tag]} found." if @tasks.empty?
      end
    end
  end

  def remove_non_tagged_tasks
    for task in @tasks
      @tasks.delete(task) unless task.tags_from(task.user).empty?
    end
  end

end
