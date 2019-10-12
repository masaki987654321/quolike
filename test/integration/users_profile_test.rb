require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "プロファイルの表示" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_match @user.questions.count.to_s, response.body
    assert_select 'div.pagination'
    @user.questions.paginate(page: 1).each do |question|
      assert_match question.content, response.body
    end
  end
  
  
end
