class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index,:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :show,:destroy, :edit_basic_info, :update_basic_info]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    if logged_in? && !current_user.admin?
      flash[:success] = "すでにログインしてます。"
      redirect_to current_user
    end
    @user = User.new
  end
  
  def show
  end
    
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "新規作成に成功しました。"
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "基本情報の更新をしました。"
      redirect_to @user
    else
      flash[:danger] = "更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
      redirect_to edit_basic_info_user_url
    end
  end
    

  private
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:basic_time, :work_time)
    end
    
    def logged_in_user
      unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end
    
    def admin_user
      flash[:danger] = "アクセス権限がありません。"
      redirect_to root_url unless current_user.admin?
    end
end
