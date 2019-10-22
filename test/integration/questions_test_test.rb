require 'test_helper'

class QuestionsTestTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @question = questions(:orange)
    @other_question = questions(:ants)
  end
  
  test "qusetion生成" do
    log_in_as(@user)
    get new_question_path
    assert_template 'questions/new'
      assert_difference 'Question.count', 1 do
        post questions_path, params: { question: { content: "Lorem ipsum", tag_list: "ruby,php,java" } }
      end
    follow_redirect!
    assert_template 'home_pages/home'
  end
  
  test "questions削除失敗" do
    log_in_as(@user)
    assert_no_difference 'Question.count' do
      delete question_path(@other_question)
    end
    assert_redirected_to root_path
  end
  
  test "questions削除成功" do
    log_in_as(@user)
    assert_difference 'Question.count', -1 do
      delete question_path(@question)
    end
    assert_redirected_to request.referrer || root_url
  end
end
