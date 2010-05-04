class BugsController < ApplicationController
  def index
    @bugs = Bug.all
  end
  
  def show
    @bug = Bug.find(params[:id])
  end
  
  def new
    @bug = Bug.new
  end
  
  def create
    @bug = Bug.new(params[:bug])
    if @bug.save
      flash[:notice] = "Successfully created bug."
      redirect_to @bug
    else
      render :action => 'new'
    end
  end
  
  def edit
    @bug = Bug.find(params[:id])
  end
  
  def update
    @bug = Bug.find(params[:id])
    if @bug.update_attributes(params[:bug])
      flash[:notice] = "Successfully updated bug."
      redirect_to @bug
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @bug = Bug.find(params[:id])
    @bug.destroy
    flash[:notice] = "Successfully destroyed bug."
    redirect_to bugs_url
  end
end
