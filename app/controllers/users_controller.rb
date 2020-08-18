class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update,]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    # todo pagenations
    @user = User.find(params[:id])

    # 解決済質問のhash作成の処理
    solved_questions = Question.where(user_id: @user.id)
                               .where.not(best_answer_id: nil)
                               .joins(:user).select("questions.*, users.name")
    solved_answers = Answer.where(questions: {user_id: @user.id})
                             .where.not(questions: {best_answer_id: nil})                 
                             .joins(:question)
                             .select("answers.*")
    @solved_questions = []
    solved_questions.each do |question|
      answer_counts = question.get_answer_count(solved_answers)
      best_answer = question.get_best_answer(solved_answers)
      @solved_questions.push(question.create_send_question_hash(answer_counts, best_answer))
    end

    # 未解決質問のhash作成の処理
    unsolved_questions = Question.where(user_id: @user.id)
                                .where(best_answer_id: nil)
                                .joins(:user).select("questions.*, users.name")
    unsolved_answers = Answer.where(questions: {user_id: @user.id})
                                .where(questions: {best_answer_id: nil})
                                .joins(:question)
                                .select("answers.*")
    @unsolved_questions = []
    unsolved_questions.each do |question|
      answer_counts = question.get_answer_count(unsolved_answers)  
      @unsolved_questions.push(question.create_send_question_hash(answer_counts))
    end

    # 回答した質問のhash作成の処理
    answerd_questions = Question.joins(:answers, :user)
                                .where(answers: {user_id: @user.id})
                                .select("questions.user_id AS question_user_id, 
                                                          answers.user_id AS answer_user_id,
                                                          answers.content AS answer_content,
                                                          users.name AS name,
                                                          questions.*")    
    answers = Answer.select("answers.question_id")
    @answerd_questions = []
    answerd_questions.each do |question|
      answer_counts = question.get_answer_count(answers)  
      @answerd_questions.push(question.create_send_question_hash(answer_counts))
    end      
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

