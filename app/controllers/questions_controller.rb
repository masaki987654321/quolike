class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def new
    @question = current_user.questions.build
  end
  
  def show
    @question = Question.find(params[:id])
    @answers = @question.answers.paginate(page: params[:page])
  end
  
  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:success] = "質問が投稿されました"
      redirect_to root_url
    else 
      render 'questions/new'
      
    end
  end

  def destroy
    @question.destroy
    flash[:success] = "質問は削除されました"
    redirect_to request.referrer || root_url
  end
  
  private

    def question_params
      params.require(:question).permit(:content)
    end

    def correct_user
      @question = current_user.questions.find_by(id: params[:id])
      redirect_to root_url if @question.nil?
    end
  
end
