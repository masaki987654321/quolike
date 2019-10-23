class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :update, :destroy]
  before_action :correct_user,   only: :destroy
  
  def new
    @question = current_user.questions.build
  end
  
  def show
    @question = Question.find(params[:id])
    @user = User.find(@question.user_id)
    @users = User.all
    if (@question.best_answer_id != nil)
      @best_answer = Answer.find(@question.best_answer_id)
      @answers = Answer.where(question_id: @question.id).where.not(id: @question.best_answer_id)
    else
      @best_answer = nil
      @answers = Answer.where(question_id: @question.id)
    end
  end
  
  def create
    @question = current_user.questions.build(question_params)
    logger.info(@question.content)
    logger.info(@question.tag_list)
    if @question.save
      flash[:success] = "質問が投稿されました"
      redirect_to root_url
    else 
      render 'questions/new'
      
    end
  end
  
  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(question_params)
      flash[:success] = "ベストアンサーを登録しました"
      redirect_to question_url(@question)
    else
      render 'questions/show'
    end
  end

  def destroy
    @question.destroy
    flash[:success] = "質問は削除されました"
    redirect_to request.referrer || root_url
  end
  
  private

    def question_params
      params.require(:question).permit(:content, :tag_list, :best_answer_id)
    end

    def correct_user
      @question = current_user.questions.find_by(id: params[:id])
      redirect_to root_url if @question.nil?
    end
  
end
