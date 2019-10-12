class HomePagesController < ApplicationController
  def home
    @questions = Question.all.paginate(page: params[:page])
  end
end
