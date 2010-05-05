class WorktypesController < ApplicationController
  def index
    @worktypes = Worktype.all
  end
  
  def show
    @worktype = Worktype.find(params[:id])
  end
  
  def new
    @worktype = Worktype.new
  end
  
  def create
    @worktype = Worktype.new(params[:worktype])
    if @worktype.save
      flash[:notice] = "Successfully created worktype."
      redirect_to @worktype
    else
      render :action => 'new'
    end
  end
  
  def edit
    @worktype = Worktype.find(params[:id])
  end
  
  def update
    @worktype = Worktype.find(params[:id])
    if @worktype.update_attributes(params[:worktype])
      flash[:notice] = "Successfully updated worktype."
      redirect_to @worktype
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @worktype = Worktype.find(params[:id])
    @worktype.destroy
    flash[:notice] = "Successfully destroyed worktype."
    redirect_to worktypes_url
  end
end
