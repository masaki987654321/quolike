class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :update, :destroy]
  before_action :correct_user,   only: :destroy
  
  def solved_index
    # todo pagenation機能の実装
    solved_questions = Question.where.not(best_answer_id: nil).joins(:user).select("questions.*, users.name")
    solved_answers = Answer.where.not(questions: {best_answer_id: nil}).joins(:question).select("answers.*")
    
    @send_questions = []
    solved_questions.each do |question|
      answer_counts = question.get_answer_count(solved_answers)
      best_answer = question.get_best_answer(solved_answers)
      @send_questions.push(question.create_send_question_hash(answer_counts, best_answer))
    end
  end

  def unsolved_index
    # todo pagenation機能の実装
    unsolved_questions = Question.where(best_answer_id: nil).joins(:user).select("questions.*, users.name")
    unsolved_answers = Answer.where(questions: {best_answer_id: nil}).joins(:question).select("answers.*")
    
    @send_questions = []
    unsolved_questions.each do |question|
      answer_counts = question.get_answer_count(unsolved_answers)
      @send_questions.push(question.create_send_question_hash(answer_counts))
    end
  end

  def new
    @question = current_user.questions.build
  end
  
  def show
    @question = Question.joins(:user).select("questions.*, users.name").find(params[:id])
    answers = Answer.joins(:question, :user).where(question_id: @question.id).select("answers.*, questions.best_answer_id, users.name")
    @answers = []
    @best_answer = nil
    @answer_count = 0

    answers.each do |answer|
      if (answer.is_best_answer?)
        @best_answer = answer
      else
        @answers.push(answer.create_answer_hash)
      end
      @answer_count += 1
    end
  end
  
  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:success] = "質問が投稿されました"
      redirect_to unsolved_questions_path
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
