require 'test_helper'

class FirefightersControllerTest < ActionController::TestCase

  setup do
    @firefighter = Fabricate(:firefighter)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:firefighters)
    assert_select '#unexpected_error', false
    assert_template "firefighters/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:firefighter)
    assert_select '#unexpected_error', false
    assert_template "firefighters/new"
  end

  test "should create firefighter" do
    assert_difference('Firefighter.count') do
      post :create, firefighter: Fabricate.attributes_for(:firefighter)
    end

    assert_redirected_to firefighter_url(assigns(:firefighter))
  end

  test "should show firefighter" do
    get :show, id: @firefighter
    assert_response :success
    assert_not_nil assigns(:firefighter)
    assert_select '#unexpected_error', false
    assert_template "firefighters/show"
  end

  test "should get edit" do
    get :edit, id: @firefighter
    assert_response :success
    assert_not_nil assigns(:firefighter)
    assert_select '#unexpected_error', false
    assert_template "firefighters/edit"
  end

  test "should update firefighter" do
    put :update, id: @firefighter, firefighter: { firstname: 'bomber' }
    assert_redirected_to firefighter_url(assigns(:firefighter))
  end

  test "should destroy firefighter" do
    assert_difference('Firefighter.count', -1) do
      delete :destroy, id: @firefighter
    end

    assert_redirected_to firefighters_url
  end
end
