class AnswersController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy
  
  def new
    @user =  current_user
    @question = Question.find(params[:question_id])
    @answer = Answer.new()
  end
  
  def create
    @answer = Answer.new(user_id: params[:answer][:user_id], question_id: params[:answer][:question_id],
                         content: params[:answer][:content])
    if @answer.save
      flash[:success] = "回答が投稿されました"
      redirect_to root_url
    else
      redirect_to new_answer_path(question_id: @answer.question_id)
    end
  end

  def destroy
    @answer.destroy
    flash[:success] = "回答は削除されました"
    redirect_to request.referrer || root_url
  end
  
  private

    def answer_params
      params.require(:answer).permit(:content)
    end

    def correct_user
      @answer = current_user.answers.find_by(id: params[:id])
      redirect_to root_url if @answer.nil?
    end
end
