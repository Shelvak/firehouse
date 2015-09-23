require 'test_helper'

class Configs::FirefightersControllerTest < ActionController::TestCase

  setup do
    @firefighter = Fabricate(:firefighter)
    @user = Fabricate(:user)
    sign_in @user
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:firefighters)
    assert_select '#unexpected_error', false
    assert_template 'configs/firefighters/index'
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:firefighter)
    assert_select '#unexpected_error', false
    assert_template 'configs/firefighters/new'
  end

  test 'should create firefighter' do
    assert_difference('Firefighter.count') do
      post :create, firefighter: Fabricate.attributes_for(:firefighter)
    end
    assert_response :redirect
    assert_not_nil assigns(:firefighter)
    assert_select '#unexpected_error', false
  end

  test 'should not create firefighter' do
    assert_no_difference('Firefighter.count') do
      post :create, firefighter: {}
    end
    assert_response :success
    assert_not_nil assigns(:firefighter)
    assert_template 'configs/firefighters/new'
    assert_select '#unexpected_error', false
    assert_select '.alert-error', true
  end

  test 'should show firefighter' do
    get :show, id: @firefighter
    assert_response :success
    assert_not_nil assigns(:firefighter)
    assert_select '#unexpected_error', false
    assert_template 'configs/firefighters/show'
  end

  test 'should get edit' do
    get :edit, id: @firefighter
    assert_response :success
    assert_not_nil assigns(:firefighter)
    assert_select '#unexpected_error', false
    assert_template 'configs/firefighters/edit'
  end

  test 'should update firefighter' do
    put :update, id: @firefighter, firefighter: { firstname: 'bomber' }

    assert_response :redirect
    assert_not_nil assigns(:firefighter)
    assert_select '#unexpected_error', false
  end

  test 'should not update firefighter' do
    put :update, id: @firefighter, firefighter: { firstname: '' }

    assert_response :success
    assert_not_nil assigns(:firefighter)
    assert_template 'configs/firefighters/edit'
    assert_select '#unexpected_error', false
    assert_select '.alert-error', true
  end

  test 'should destroy firefighter' do
    assert_difference('Firefighter.count', -1) do
      xhr :delete, :destroy, id: @firefighter
    end
    assert_response :success
  end
end
