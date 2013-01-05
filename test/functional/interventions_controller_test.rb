require 'test_helper'

class InterventionsControllerTest < ActionController::TestCase

  setup do
    @intervention = Fabricate(:intervention)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:interventions)
    assert_select '#unexpected_error', false
    assert_template "interventions/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:intervention)
    assert_select '#unexpected_error', false
    assert_template "interventions/new"
  end

  test "should create intervention" do
    assert_difference('Intervention.count') do
      post :create, intervention: Fabricate.attributes_for(:intervention)
    end

    assert_redirected_to intervention_url(assigns(:intervention))
  end

  test "should show intervention" do
    get :show, id: @intervention
    assert_response :success
    assert_not_nil assigns(:intervention)
    assert_select '#unexpected_error', false
    assert_template "interventions/show"
  end

  test "should get edit" do
    get :edit, id: @intervention
    assert_response :success
    assert_not_nil assigns(:intervention)
    assert_select '#unexpected_error', false
    assert_template "interventions/edit"
  end

  test "should update intervention" do
    put :update, id: @intervention, 
      intervention: Fabricate.attributes_for(:intervention)
    assert_redirected_to intervention_url(assigns(:intervention))
  end

  test "should destroy intervention" do
    assert_difference('Intervention.count', -1) do
      delete :destroy, id: @intervention
    end

    assert_redirected_to interventions_url
  end
end
