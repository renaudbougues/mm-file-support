class AccessGroupsController < ApplicationController
  before_action :set_access_group, only: [:show, :edit, :update, :destroy]
  before_filter :ensure_logged_in
  # GET /access_groups
  # GET /access_groups.json
  def index
    @access_groups = current_user.owned_groups
  end

  # GET /access_groups/1
  # GET /access_groups/1.json
  def show
  end

  # GET /access_groups/new
  def new
    @access_group = AccessGroup.new
    @projects = current_user.owned_projects.order(:name)    
  end

  # GET /access_groups/1/edit
  def edit
    @projects = current_user.owned_projects.order(:name)    
  end

  # POST /access_groups
  # POST /access_groups.json
  def create
    @access_group = AccessGroup.new(access_group_params)
    @access_group.creator_id = current_user.id
    @projects = current_user.owned_projects.order(:name)    
    respond_to do |format|
      if @access_group.save
        format.html { redirect_to @access_group, notice: 'Access group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @access_group }
      else
        format.html { render action: 'new' }
        format.json { render json: @access_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /access_groups/1
  # PATCH/PUT /access_groups/1.json
  def update
    @projects = current_user.owned_projects.order(:name)    
    respond_to do |format|
      if @access_group.update(access_group_params)
        format.html { redirect_to @access_group, notice: 'Access group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @access_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /access_groups/1
  # DELETE /access_groups/1.json
  def destroy
    @access_group.destroy
    respond_to do |format|
      format.html { redirect_to access_groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_access_group
      @access_group = AccessGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def access_group_params
      params.require(:access_group).permit(:name, :creator_id, :user_ids => [], :project_ids => [])      
    end
end