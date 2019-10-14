require 'test_helper'

class AnswersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @answer = answers(:orange)
    @question = questions(:orange)
  end
  
  test "未ログイン時のnewアクション" do
    get new_answer_path(question_id: @question.id)
    assert_redirected_to login_url
  end
  
  test "未ログイン時のanswer作成" do
    assert_no_difference 'Answer.count' do
      post answers_path, params: { answer: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end
  
  test "未ログイン時のanswer削除" do
    assert_no_difference 'Answer.count' do
      delete answer_path(@answer)
    end
    assert_redirected_to login_url
  end
end
