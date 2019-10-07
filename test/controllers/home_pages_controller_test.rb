require 'test_helper'

class HomePagesControllerTest < ActionDispatch::IntegrationTest
  
  test "homeの表示" do
    get root_url
    assert_response :success
  end

end
