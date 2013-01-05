require 'test_helper'

class HierarchiesControllerTest < ActionController::TestCase

  setup do
    @hierarchy = Fabricate(:hierarchy)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hierarchies)
    assert_select '#unexpected_error', false
    assert_template "hierarchies/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:hierarchy)
    assert_select '#unexpected_error', false
    assert_template "hierarchies/new"
  end

  test "should create hierarchy" do
    assert_difference('Hierarchy.count') do
      post :create, hierarchy: Fabricate.attributes_for(:hierarchy)
    end

    assert_redirected_to hierarchy_url(assigns(:hierarchy))
  end

  test "should show hierarchy" do
    get :show, id: @hierarchy
    assert_response :success
    assert_not_nil assigns(:hierarchy)
    assert_select '#unexpected_error', false
    assert_template "hierarchies/show"
  end

  test "should get edit" do
    get :edit, id: @hierarchy
    assert_response :success
    assert_not_nil assigns(:hierarchy)
    assert_select '#unexpected_error', false
    assert_template "hierarchies/edit"
  end

  test "should update hierarchy" do
    put :update, id: @hierarchy, 
      hierarchy: Fabricate.attributes_for(:hierarchy)
    assert_redirected_to hierarchy_url(assigns(:hierarchy))
  end

  test "should destroy hierarchy" do
    assert_difference('Hierarchy.count', -1) do
      delete :destroy, id: @hierarchy
    end

    assert_redirected_to hierarchies_path
  end
end
