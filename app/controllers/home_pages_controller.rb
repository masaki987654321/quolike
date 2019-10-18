class HomePagesController < ApplicationController
  def home
    @questions = User.joins(:questions)
                     .select("users.id AS user_id, questions.id AS question_id, questions.*, users.*")
                     .all.paginate(page: params[:page],  per_page: 10)
  end
end
