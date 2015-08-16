class UsersController < ApplicationController
  before_filter :load_current_user, only: [:edit_profile, :update_profile]
  before_filter :authenticate_user!

  check_authorization
  load_and_authorize_resource

  # GET /users
  # GET /users.json
  def index
    @title = t 'view.users.index_title'
    @searchable = true
    @users = @users.filtered_list(params[:q]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
      format.js   # index.js.erb
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @title = t 'view.users.show_title'

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @title = t 'view.users.new_title'

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @title = t 'view.users.edit_title'
  end

  # POST /users
  # POST /users.json
  def create
    @title = t 'view.users.new_title'

    if @user.save
      redirect_to @user, notice: t('view.users.correctly_created')
    else
      render action: 'new'
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    authorize! :assign_roles, @user if params[:user] && params[:user][:roles]
    @title = t 'view.users.edit_title'

    if @user.update_attributes(params[:user])
      redirect_to @user, notice: t('view.users.correctly_updated')
    else
      render action: 'edit'
    end

  rescue ActiveRecord::StaleObjectError
    flash.alert = t 'view.users.stale_object_error'
    redirect_to edit_user_url(@user)
  end

  # GET /users/1/edit_profile
  def edit_profile
    @title = t('view.users.edit_profile')
  end

  # PUT /users/1/update_profile
  # PUT /users/1/update_profile.xml
  def update_profile
    @title = t('view.users.edit_profile')

    if @user.update_attributes(params[:user])
      redirect_to edit_profile_user_url(@user),
        notice: t('view.users.profile_correctly_updated')
    else
      render action: 'edit_profile'
    end

  rescue ActiveRecord::StaleObjectError
    flash.alert = t('view.users.stale_object_error')
    redirect_to edit_profile_user_url(@user)
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    redirect_to users_url
  end

  def autocomplete_for_hierarchy_name
    hierarchies = Hierarchy.filtered_list(params[:q]).limit(5)

    respond_to do |format|
      format.json { render json: hierarchies }
    end
  end

  def autocomplete_for_user_name
    users = User.filtered_list(params[:q]).limit(5)

    respond_to do |format|
      format.json { render json: users }
    end
  end


  private

    def load_current_user
      @user = current_user
    end
end
