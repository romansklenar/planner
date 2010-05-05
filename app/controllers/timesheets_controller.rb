class TimesheetsController < ApplicationController
  def index
    @timesheets = Timesheet.all
  end
  
  def show
    @timesheet = Timesheet.find(params[:id])
  end
  
  def new
    @timesheet = Timesheet.new
  end
  
  def create
    @timesheet = Timesheet.new(params[:timesheet])
    if @timesheet.save
      flash[:notice] = "Successfully created timesheet."
      redirect_to @timesheet
    else
      render :action => 'new'
    end
  end
  
  def edit
    @timesheet = Timesheet.find(params[:id])
  end
  
  def update
    @timesheet = Timesheet.find(params[:id])
    if @timesheet.update_attributes(params[:timesheet])
      flash[:notice] = "Successfully updated timesheet."
      redirect_to @timesheet
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @timesheet = Timesheet.find(params[:id])
    @timesheet.destroy
    flash[:notice] = "Successfully destroyed timesheet."
    redirect_to timesheets_url
  end
end
