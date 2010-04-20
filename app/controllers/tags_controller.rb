class TagsController < ApplicationController
  before_filter :require_user
  before_filter :load_collection, :only => ['index']

private

  def load_collection
    @projects = current_user.projects
    @tasks = current_user.tasks
  end

  def apply_search(collection)
    collection = collection.tagged_with([params[:search]]) if params.has_key?(:search)
    return collection
  end

  def find_taggable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end

    return nil
  end


public

  def index
    @projects = apply_search(@projects)
    @tasks = apply_search(@tasks)
    if params.has_key?(:search) and @projects.empty? and @tasks.empty?
      flash[:notice] = "Nothing found for tag '#{params[:search]}'."
    end
    render
  end

  # GET /tags/new
  # GET /tags/new.xml
  def new
    @tag = Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  # POST /tags
  # POST /tags.xml
  def create
    @taggable = find_taggable
    tags = @taggable.tags_from(@user)
    @tag = @user.tag(@taggable, :with => tags << params[:tags], :on => :tags)

    respond_to do |format|
      if @tag
        flash[:notice] = 'Tag(s) was successfully created.'
        # format.html { redirect_to :id => nil }
        format.xml  { render :xml => @tag, :status => :created, :location => @tag }
      else
        # format.html { render :action => "new" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
  end

  # PUT /tags/1
  # PUT /tags/1.xml
  def update
    @tag = Tag.find(params[:id])

    respond_to do |format|
      if @tag.update_attributes(params[:tag])
        flash[:notice] = 'Tag was successfully updated.'
        format.html { redirect_to(@tag) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.xml
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    respond_to do |format|
      format.html { redirect_to(tags_url) }
      format.xml  { head :ok }
    end
  end
end