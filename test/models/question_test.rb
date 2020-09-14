require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @question = Question.new(content: "Lorem ipsum", 
                             user_id: @user.id)
  end

  test "有効性のテスト" do
    assert @question.valid?
  end

  test "user=idが空のテスト" do
    @question.user_id = nil
    assert_not @question.valid?
  end
  
  test "contentが空のテスト" do
    @question.content = "   "
    assert_not @question.valid?
  end

  test "contentが200文字以上のテスト" do
    @question.content = "a" * 201
    assert_not @question.valid?
  end
  
  test "投稿日時順に並んでいるかのテスト" do
    assert_equal questions(:most_recent), Question.first
  end
end
