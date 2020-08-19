class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 200 }
  acts_as_taggable

  # 回答数取得の処理
  def get_answer_count(answers)
    answer_counts = 0
    answers.each do |answer|
      if(answer.question_id == self.id)
        answer_counts += 1
      end
    end
    return answer_counts
  end

  # ベストアンサー取得の処理
  def get_best_answer(answers)
    best_answer = ''
    answers.each do |answer|
      if(answer.id == self.best_answer_id)
        best_answer = answer.content
      end
    end
    return best_answer
  end

  # viewへ送るquestionのhashを作成する処理
  # answer_count, best_answerの情報を追加するため
  def create_send_question_hash(answer_counts, best_answer=nil)
    send_question = {
      id: self.id,
      content: self.content,
      user_id: self.user_id,
      updated_at: self.updated_at,
      user_name: self.name,
      answer_counts: answer_counts,
      best_answer: best_answer
    }
    return send_question
  end
end
