require 'test_helper'

class Configs::HierarchiesControllerTest < ActionController::TestCase

  setup do
    @hierarchy = Fabricate(:hierarchy)
    @user = Fabricate(:user)
    sign_in @user
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:hierarchies)
    assert_select '#unexpected_error', false
    assert_template 'configs/hierarchies/index'
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:hierarchy)
    assert_select '#unexpected_error', false
    assert_template 'configs/hierarchies/new'
  end

  test 'should create hierarchy' do
    assert_difference('Hierarchy.count') do
      post :create, hierarchy: Fabricate.attributes_for(:hierarchy)
    end

    assert_redirected_to configs_hierarchy_url(assigns(:hierarchy))
  end

  test 'should show hierarchy' do
    get :show, id: @hierarchy
    assert_response :success
    assert_not_nil assigns(:hierarchy)
    assert_select '#unexpected_error', false
    assert_template 'configs/hierarchies/show'
  end

  test 'should get edit' do
    get :edit, id: @hierarchy
    assert_response :success
    assert_not_nil assigns(:hierarchy)
    assert_select '#unexpected_error', false
    assert_template 'configs/hierarchies/edit'
  end

  test 'should update hierarchy' do
    put :update, id: @hierarchy, 
      hierarchy: Fabricate.attributes_for(:hierarchy)
    assert_redirected_to configs_hierarchy_url(assigns(:hierarchy))
  end

  test 'should destroy hierarchy' do
    assert_difference('Hierarchy.count', -1) do
      delete :destroy, id: @hierarchy
    end

    assert_redirected_to configs_hierarchies_path
  end
end
