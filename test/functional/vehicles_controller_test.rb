require 'test_helper'

class VehiclesControllerTest < ActionController::TestCase

  setup do
    @vehicle = Fabricate(:vehicle)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vehicles)
    assert_select '#unexpected_error', false
    assert_template "vehicles/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:vehicle)
    assert_select '#unexpected_error', false
    assert_template "vehicles/new"
  end

  test "should create vehicle" do
    assert_difference('Vehicle.count') do
      post :create, vehicle: Fabricate.attributes_for(:vehicle)
    end

    assert_redirected_to vehicle_url(assigns(:vehicle))
  end

  test "should show vehicle" do
    get :show, id: @vehicle
    assert_response :success
    assert_not_nil assigns(:vehicle)
    assert_select '#unexpected_error', false
    assert_template "vehicles/show"
  end

  test "should get edit" do
    get :edit, id: @vehicle
    assert_response :success
    assert_not_nil assigns(:vehicle)
    assert_select '#unexpected_error', false
    assert_template "vehicles/edit"
  end

  test "should update vehicle" do
    put :update, id: @vehicle, 
      vehicle: Fabricate.attributes_for(:vehicle, attr: 'value')
    assert_redirected_to vehicle_url(assigns(:vehicle))
  end

  test "should destroy vehicle" do
    assert_difference('Vehicle.count', -1) do
      delete :destroy, id: @vehicle
    end

    assert_redirected_to vehicles_path
  end
end
