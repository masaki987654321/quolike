class HomePagesController < ApplicationController
  def home
    # todo questionsにuserをjoinする
    @users = User.all
    @questions = Question.all.paginate(page: params[:page], per_page: 10)
  end
end
