require 'test_helper'

class BuildingsControllerTest < ActionController::TestCase

  setup do
    @building = Fabricate(:building)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:buildings)
    assert_select '#unexpected_error', false
    assert_template "buildings/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:building)
    assert_select '#unexpected_error', false
    assert_template "buildings/new"
  end

  test "should create building" do
    assert_difference('Building.count') do
      post :create, building: Fabricate.attributes_for(:building)
    end

    assert_redirected_to building_url(assigns(:building))
  end

  test "should show building" do
    get :show, id: @building
    assert_response :success
    assert_not_nil assigns(:building)
    assert_select '#unexpected_error', false
    assert_template "buildings/show"
  end

  test "should get edit" do
    get :edit, id: @building
    assert_response :success
    assert_not_nil assigns(:building)
    assert_select '#unexpected_error', false
    assert_template "buildings/edit"
  end

  test "should update building" do
    put :update, id: @building, 
      building: Fabricate.attributes_for(:building, attr: 'value')
    assert_redirected_to building_url(assigns(:building))
  end

  test "should destroy building" do
    assert_difference('Building.count', -1) do
      delete :destroy, id: @building
    end

    assert_redirected_to buildings_path
  end
end
