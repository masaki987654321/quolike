require 'test_helper'

class AnswersTestTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @question = questions(:orange)
    @other_question = questions(:ants)
    @answer= answers(:orange)
    @other_answer = answers(:tau_manifesto)
  end
  
  test "answer生成" do
    log_in_as(@user)
    get new_answer_path(question_id: @question.id)
    assert_template 'answers/new'
     assert_difference 'Answer.count', 1 do
      post answers_path, params: { answer: { user_id: @user.id,
                                             question_id: @question.id,
                                             content: "Lorem ipsum" } }
    end
    follow_redirect!
    assert_template 'home_pages/home'
  end
  
  test "answer削除失敗" do
    log_in_as(@user)
    assert_no_difference 'Answer.count' do
      delete answer_path(@other_answer)
    end
    assert_redirected_to root_path
  end
  
  test "answer削除成功" do
    log_in_as(@user)
    assert_difference 'Answer.count', -1 do
      delete answer_path(@answer)
    end
    assert_redirected_to request.referrer || root_url
  end
end
