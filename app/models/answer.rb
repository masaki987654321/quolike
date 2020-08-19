class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :question_id, presence: true
  validates :content, presence: true, length: { maximum: 1000 }

  def is_best_answer?
    if (self.id == self.best_answer_id)
      return true
    else
      return false
    end
  end

  def create_answer_hash
    answer = {
      id: self.id,
      content: self.content,
      user_id: self.user_id,
      updated_at: self.updated_at,
      user_name: self.name,
    }
    return answer
  end
end
