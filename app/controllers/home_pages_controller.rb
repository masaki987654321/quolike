class HomePagesController < ApplicationController
  def home
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
end
