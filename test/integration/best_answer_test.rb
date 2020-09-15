require 'test_helper'

class BestAnswerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @question = questions(:orange)
    @answer = answers(:orange)
  end
  
  test "ベストアンサー登録成功" do
    log_in_as(@user)
    patch designate_best_answer_path(id: @question.id, best_answer_id: @answer.id)
    assert_not flash.empty?
    @question.reload
    assert_equal @answer.id, @question.best_answer_id
  end

  test "fail designating best answer" do
    log_in_as(@user)
    patch designate_best_answer_path(id: @question.id, best_answer_id: "string is not permited")
    follow_redirect!
    assert_template 'questions/show'
  end
end
