class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :update, :destroy]
  before_action :correct_user,   only: :destroy
  
  def solved_index
    # todo pagenation機能の実装
    solved_questions = Question.where.not(best_answer_id: nil).joins(:user).select("questions.*, users.name").paginate(page: params[:page], per_page: 10)
    solved_answers = Question.where.not(best_answer_id: nil).joins(:answers).select("answers.*")
    
    @send_questions = []
    
    solved_questions.each do |question|
      answer_counts = question.get_answer_count(solved_answers)
      best_answer = question.get_best_answer(solved_answers)

      send_question = {
        id: question.id,
        content: question.content,
        user_id: question.user_id,
        updated_at: question.updated_at,
        user_name: question.name,
        answer_counts: answer_counts,
        best_answer: best_answer
      }

      @send_questions.push(send_question)
    end
  end

  def unsolved_index
    # todo pagenation機能の実装
    solved_questions = Question.where(best_answer_id: nil).joins(:user).select("questions.*, users.name").paginate(page: params[:page], per_page: 10)
    solved_answers = Question.where(best_answer_id: nil).joins(:answers).select("answers.*")
    
    @send_questions = []
    
    solved_questions.each do |question|
      answer_counts = question.get_answer_count(solved_answers)
      
      send_question = {
        id: question.id,
        content: question.content,
        user_id: question.user_id,
        updated_at: question.updated_at,
        user_name: question.name,
        answer_counts: answer_counts,
      }
      
      @send_questions.push(send_question)
    end
  end

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
