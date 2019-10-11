require 'test_helper'

class UsersShowTestTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "アカウント削除のテスト" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_difference('User.count', -1) do
      delete user_path(@user)
    end
  end
end
