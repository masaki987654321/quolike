class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update,]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @questions = @user.questions.paginate(page: params[:page])
    @answers = @user.answers.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user =User.new(user_params)
    if @user.save
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を変更しました"
      redirect_to @user
    else
      render 'edit'
    end   
  end
  
  def destroy
    User.find(current_user.id).destroy
    flash[:success] = "ユーザを削除しました"
    redirect_to root_url
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    
    # beforeアクション

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end
  
end

