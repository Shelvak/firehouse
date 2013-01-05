require 'test_helper'

class ScosControllerTest < ActionController::TestCase

  setup do
    @sco = Fabricate(:sco)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scos)
    assert_select '#unexpected_error', false
    assert_template "scos/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:sco)
    assert_select '#unexpected_error', false
    assert_template "scos/new"
  end

  test "should create sco" do
    assert_difference('Sco.count') do
      post :create, sco: Fabricate.attributes_for(:sco)
    end

    assert_redirected_to sco_url(assigns(:sco))
  end

  test "should show sco" do
    get :show, id: @sco
    assert_response :success
    assert_not_nil assigns(:sco)
    assert_select '#unexpected_error', false
    assert_template "scos/show"
  end

  test "should get edit" do
    get :edit, id: @sco
    assert_response :success
    assert_not_nil assigns(:sco)
    assert_select '#unexpected_error', false
    assert_template "scos/edit"
  end

  test "should update sco" do
    put :update, id: @sco, 
      sco: Fabricate.attributes_for(:sco)
    assert_redirected_to sco_url(assigns(:sco))
  end

  test "should destroy sco" do
    assert_difference('Sco.count', -1) do
      delete :destroy, id: @sco
    end

    assert_redirected_to scos_path
  end
end
