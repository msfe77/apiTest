require 'test_helper'

class ApiControllerControllerTest < ActionController::TestCase
  test "should get api_view" do
    get :api_view
    assert_response :success
  end

end
