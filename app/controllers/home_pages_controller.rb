class HomePagesController < ApplicationController
  def home
    @users = User.all
    @questions = Question.all.paginate(page: params[:page], per_page: 10)
    
    if params[:tag_name]
      @questions = @questions.tagged_with("#{params[:tag_name]}")
                             .paginate(page: params[:page], per_page: 10)
    end
  end
end
