class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!
  before_action :find_user, only: [:block_user, :destroy]

  def index
    @status = params[:blocked] || false
    @users = User.contestants.where(blocked: @status).desc(:created_at).page(params[:page])
    if request.xhr?
      respond_to do |format|
        format.js
      end
    end
  end

  def mark_as_judge
    User.find(params[:user_id]).set(is_judge: params[:flag])
    redirect_to admin_users_path
  end

  def login_as
    user = User.find(params[:user_id])
    if user
      sign_in :user, user
    end
    redirect_to root_path
  end

  def block_user
    @user.update(blocked: params[:blocked]) if @user
  end

  def search
    if params[:q].blank?
      redirect_to admin_users_path
      return
    end
    @status = params[:status]
    @users = User.contestants.where(blocked: params[:status], github_handle: /#{params[:q]}/)
    @users = User.contestants.where(blocked: params[:status], email: params[:q]) if @users.none?
    @users = @users.page(params[:page])

    render :index
  end

  def destroy
    if @user
      @user.destroy
      redirect_to admin_users_path, notice: "#{@user.name} has been deleted successfully"
    else
      redirect_to admin_users_path, notice: "User not found"
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
