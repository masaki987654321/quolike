require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                                           password: "foobar", password_confirmation: "foobar")
  end
  
  test "有効なモデルに対するテスト" do
    assert @user.valid?
  end
  
  test "無効なname(空)" do
    @user.name = " "
    assert_not @user.valid?
  end
  
  test "無効なemail(空)" do
    @user.email = " "
    assert_not @user.valid?
  end
  
  test "無効なname(長すぎる)" do
    @user.email = "a"*51
    assert_not @user.valid?
  end
  
  test "無効なemail(長すぎる)" do
    @user.email = "a"*244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "無効なemail(メールアドレスの形式でない)" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "無効なemail(重複)" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "メールアドレスの小文字化に対するテスト" do
    mixed_case_email = "Foo@ExAMPle.Com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "無効なパスワード(5文字以下)" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "無効なパスワード(空)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "userの削除とquestionの削除が連動しているか" do
    @user.save
    @user.questions.create!(content: "Lorem ipsum")
    assert_difference 'Question.count', -1 do
      @user.destroy
    end
  end

end

