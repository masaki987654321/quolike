require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @question = questions(:orange)
  end
  
  test "未ログイン時のnewアクション" do
    get new_question_path
    assert_redirected_to login_url
  end
  
  test "未ログイン時のquestion作成" do
    assert_no_difference 'Question.count' do
      post questions_path, params: { question: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end
  
  test "未ログイン時のquestion削除" do
    assert_no_difference 'Question.count' do
      delete question_path(@question)
    end
    assert_redirected_to login_url
  end
end
