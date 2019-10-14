require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    @question = questions(:ants)
    @answer = Answer.new(content: "Lorem ipsum", user_id: @user.id, question_id: @question.id)
  end

  test "有効なanswer" do
    assert @answer.valid?
  end

  test "無効なanswer(user_idが空)" do
    @answer.user_id = nil
    assert_not @answer.valid?
  end
  
  test "無効なanswer(question_idが空)" do
    @answer.question_id = nil
    assert_not @answer.valid?
  end
  
  test "無効なanswer(contentが空)" do
    @answer.content = nil
    assert_not @answer.valid?
  end
  
  test "無効なanswer(contentが1001文字以上)" do
    @answer.content = "a" * 1001
    assert_not @answer.valid?
  end
  
  test "userの削除とanswerの削除が連動しているか" do
    @answer.save
    assert_difference 'Answer.count', -4 do
      @user.destroy
    end
  end
  
  test "questionの削除とanswerの削除が連動しているか" do
    @answer.save
    assert_difference 'Answer.count', -1do
      @question.destroy
    end
  end
end
