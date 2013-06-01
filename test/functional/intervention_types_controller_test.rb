require 'test_helper'

class InterventionTypesControllerTest < ActionController::TestCase

  setup do
    @intervention_type = Fabricate(:intervention_type)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:intervention_types)
    assert_select '#unexpected_error', false
    assert_template "intervention_types/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:intervention_type)
    assert_select '#unexpected_error', false
    assert_template "intervention_types/new"
  end

  test "should create intervention_type" do
    assert_difference('InterventionType.count') do
      post :create, intervention_type: Fabricate.attributes_for(:intervention_type)
    end

    assert_redirected_to intervention_type_url(assigns(:intervention_type))
  end

  test "should show intervention_type" do
    get :show, id: @intervention_type
    assert_response :success
    assert_not_nil assigns(:intervention_type)
    assert_select '#unexpected_error', false
    assert_template "intervention_types/show"
  end

  test "should get edit" do
    get :edit, id: @intervention_type
    assert_response :success
    assert_not_nil assigns(:intervention_type)
    assert_select '#unexpected_error', false
    assert_template "intervention_types/edit"
  end

  test "should update intervention_type" do
    put :update, id: @intervention_type, 
      intervention_type: Fabricate.attributes_for(:intervention_type, attr: 'value')
    assert_redirected_to intervention_type_url(assigns(:intervention_type))
  end

  test "should destroy intervention_type" do
    assert_difference('InterventionType.count', -1) do
      delete :destroy, id: @intervention_type
    end

    assert_redirected_to configs_intervention_types_path
  end
end
