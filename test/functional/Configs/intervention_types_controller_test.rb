require 'test_helper'

class Configs::InterventionTypesControllerTest < ActionController::TestCase

  setup do
    @intervention_type = Fabricate(:intervention_type)
    @user = Fabricate(:user)
    sign_in @user
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:intervention_types)
    assert_select '#unexpected_error', false
    assert_template 'intervention_types/index'
  end

  test 'should get new' do
    xhr :get, :new
    assert_response :success
    assert_not_nil assigns(:intervention_type)
    assert_select '#unexpected_error', false
    assert_template 'intervention_types/_new'
    assert_template 'intervention_types/_form'
  end

  test 'should get new children' do
    xhr :get, :new, father: Fabricate(:intervention_type)
    assert_response :success
    assert_not_nil assigns(:intervention_type)
    assert_not_nil assigns(:father)
    assert_select '#unexpected_error', false
    assert_template 'intervention_types/_new'
    assert_template 'intervention_types/_form'
  end

  test 'should create intervention_type' do
    assert_difference('InterventionType.count') do
      post :create, intervention_type: Fabricate.attributes_for(:intervention_type)
    end
    assert_response :success
    assert_not_nil assigns(:intervention_type)
    assert_template 'intervention_types/_intervention_type'
  end

  test 'should create a children for an existent intervention_type' do
    @father = InterventionType.create Fabricate.attributes_for(:intervention_type)
    @intervention_type = Fabricate.attributes_for(:intervention_type)
    assert_difference('InterventionType.count') do
      post :create, father: @father.id, intervention_type: @intervention_type
    end
    assert_response :success
    assert_equal assigns(:intervention_type), @father.reload.children.first
    assert_template 'intervention_types/_intervention_type'
  end

  test 'should get edit' do
    xhr :get, :edit, id: @intervention_type
    assert_response :success
    assert_not_nil assigns(:intervention_type)
    assert_select '#unexpected_error', false
    assert_template 'intervention_types/_edit'
    assert_template 'intervention_types/_form'
  end

  test 'should update intervention_type' do
    xhr :put, :update, id: @intervention_type,
      intervention_type: Fabricate.attributes_for(:intervention_type, name: 'value')
    assert_response :success
    assert_not_nil assigns(:intervention_type)
    assert_template 'intervention_types/_intervention_type'
  end

  test 'should destroy intervention_type' do
    assert_difference('InterventionType.count', -1) do
      delete :destroy, id: @intervention_type
    end

    assert_response :success
    assert_template nil
  end
end
