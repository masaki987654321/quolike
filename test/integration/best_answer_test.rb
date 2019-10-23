require 'test_helper'

class BestAnswerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @question = questions(:orange)
    @answer = answers(:orange)
  end
  
  test "ベストアンサー登録成功" do
    log_in_as(@user)
    patch question_path(@question), params: {question: { best_answer_id: @answer.id } }
    assert_not flash.empty?
    @question.reload
    assert_equal @answer.id, @question.best_answer_id
  end
end
