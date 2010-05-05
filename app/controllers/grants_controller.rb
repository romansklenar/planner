class GrantsController < ApplicationController
  def index
    @grants = Grant.all
  end
  
  def show
    @grant = Grant.find(params[:id])
  end
  
  def new
    @grant = Grant.new
  end
  
  def create
    @grant = Grant.new(params[:grant])
    if @grant.save
      flash[:notice] = "Successfully created grant."
      redirect_to @grant
    else
      render :action => 'new'
    end
  end
  
  def edit
    @grant = Grant.find(params[:id])
  end
  
  def update
    @grant = Grant.find(params[:id])
    if @grant.update_attributes(params[:grant])
      flash[:notice] = "Successfully updated grant."
      redirect_to @grant
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @grant = Grant.find(params[:id])
    @grant.destroy
    flash[:notice] = "Successfully destroyed grant."
    redirect_to grants_url
  end
end
