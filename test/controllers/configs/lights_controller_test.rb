require 'test_helper'

class Configs::LightsControllerTest < ActionController::TestCase
  test "should get brightness" do
    get :brightness
    assert_response :success
  end

end
