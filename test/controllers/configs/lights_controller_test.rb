require 'test_helper'

class Configs::LightsControllerTest < ActionController::TestCase
  setup do
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get brightness" do
    get :brightness
    assert_response :success
  end
end
