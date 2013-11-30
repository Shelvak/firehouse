require 'test_helper'

class Configs::TrucksControllerTest < ActionController::TestCase

  setup do
    @truck = Fabricate(:truck)
    @user = Fabricate(:user)
    sign_in @user
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:trucks)
    assert_select '#unexpected_error', false
    assert_template 'configs/trucks/index'
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:truck)
    assert_select '#unexpected_error', false
    assert_template 'configs/trucks/new'
  end

  test 'should create truck' do
    assert_difference('Truck.count') do
      post :create, truck: Fabricate.attributes_for(:truck)
    end

    assert_redirected_to configs_truck_url(assigns(:truck))
  end

  test 'should show truck' do
    get :show, id: @truck
    assert_response :success
    assert_not_nil assigns(:truck)
    assert_select '#unexpected_error', false
    assert_template 'configs/trucks/show'
  end

  test 'should get edit' do
    get :edit, id: @truck
    assert_response :success
    assert_not_nil assigns(:truck)
    assert_select '#unexpected_error', false
    assert_template 'configs/trucks/edit'
  end

  test 'should update truck' do
    put :update, id: @truck, 
      truck: Fabricate.attributes_for(:truck)
    assert_redirected_to configs_truck_url(assigns(:truck))
  end

  test 'should destroy truck' do
    assert_difference('Truck.count', -1) do
      delete :destroy, id: @truck
    end

    assert_redirected_to configs_trucks_path
  end
end
