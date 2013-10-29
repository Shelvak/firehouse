require 'test_helper'

class TrackingMapsControllerTest < ActionController::TestCase

  setup do
    @user = Fabricate(:user)
    sign_in @user
  end

  test 'should get fullscreen' do
    get :fullscreen
    assert_response :success
    assert_not_nil assigns(:interventions)
    assert_select '#unexpected_error', false
    assert_template 'tracking_maps/fullscreen'
  end
end
