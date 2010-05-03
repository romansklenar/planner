class TasklistsController < ApplicationController
  def index
    @tasklists = Tasklist.all
  end
  
  def show
    @tasklist = Tasklist.find(params[:id])
  end
  
  def new
    @tasklist = Tasklist.new
  end
  
  def create
    @tasklist = Tasklist.new(params[:tasklist])
    if @tasklist.save
      flash[:notice] = "Successfully created tasklist."
      redirect_to @tasklist
    else
      render :action => 'new'
    end
  end
  
  def edit
    @tasklist = Tasklist.find(params[:id])
  end
  
  def update
    @tasklist = Tasklist.find(params[:id])
    if @tasklist.update_attributes(params[:tasklist])
      flash[:notice] = "Successfully updated tasklist."
      redirect_to @tasklist
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @tasklist = Tasklist.find(params[:id])
    @tasklist.destroy
    flash[:notice] = "Successfully destroyed tasklist."
    redirect_to tasklists_url
  end
end