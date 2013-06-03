require 'test_helper'

class MobileInterventionsControllerTest < ActionController::TestCase

  setup do
    @mobile_intervention = Fabricate(:mobile_intervention)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mobile_interventions)
    assert_select '#unexpected_error', false
    assert_template "mobile_interventions/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:mobile_intervention)
    assert_select '#unexpected_error', false
    assert_template "mobile_interventions/new"
  end

  test "should create mobile_intervention" do
    assert_difference('MobileIntervention.count') do
      post :create, mobile_intervention: Fabricate.attributes_for(:mobile_intervention)
    end

    assert_redirected_to mobile_intervention_url(assigns(:mobile_intervention))
  end

  test "should show mobile_intervention" do
    get :show, id: @mobile_intervention
    assert_response :success
    assert_not_nil assigns(:mobile_intervention)
    assert_select '#unexpected_error', false
    assert_template "mobile_interventions/show"
  end

  test "should get edit" do
    get :edit, id: @mobile_intervention
    assert_response :success
    assert_not_nil assigns(:mobile_intervention)
    assert_select '#unexpected_error', false
    assert_template "mobile_interventions/edit"
  end

  test "should update mobile_intervention" do
    put :update, id: @mobile_intervention, 
      mobile_intervention: Fabricate.attributes_for(:mobile_intervention, attr: 'value')
    assert_redirected_to mobile_intervention_url(assigns(:mobile_intervention))
  end

  test "should destroy mobile_intervention" do
    assert_difference('MobileIntervention.count', -1) do
      delete :destroy, id: @mobile_intervention
    end

    assert_redirected_to mobile_interventions_path
  end
end
