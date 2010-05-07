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
      redirect_to bugs_url
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
      redirect_to bugs_url
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


  def approve
    @bug = Bug.find(params[:id])
    @bug.approve!
    @bug.save
    flash[:notice] = "Bug #{@bug.name} was approved to solving"
    redirect_to bugs_url
  end
  
  def assign
    @bug = Bug.find(params[:id])
    @bug.assign!
    @bug.save
    flash[:notice] = "Bug #{@bug.name} was assigned to user #{@bug.actual_user.login.capitalize}"
    redirect_to bugs_url
  end


  # Sorts bugs inside project
  def sort
    params[:bugs].each_with_index do |id, index|
      Bug.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end
end
