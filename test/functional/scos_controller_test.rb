require 'test_helper'

class Configs::ScosControllerTest < ActionController::TestCase

  setup do
    @sco = Fabricate(:sco)
    @user = Fabricate(:user)
    sign_in @user
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:scos)
    assert_select '#unexpected_error', false
    assert_template 'configs/scos/index'
  end

  test 'should get new' do
    get :new
    assert_response :success
    assert_not_nil assigns(:sco)
    assert_select '#unexpected_error', false
    assert_template 'configs/scos/new'
  end

  test 'should create sco' do
    assert_difference('Sco.count') do
      post :create, sco: Fabricate.attributes_for(:sco)
    end

    assert_redirected_to configs_sco_url(assigns(:sco))
  end

  test 'should show sco' do
    get :show, id: @sco
    assert_response :success
    assert_not_nil assigns(:sco)
    assert_select '#unexpected_error', false
    assert_template 'configs/scos/show'
  end

  test 'should get edit' do
    get :edit, id: @sco
    assert_response :success
    assert_not_nil assigns(:sco)
    assert_select '#unexpected_error', false
    assert_template 'configs/scos/edit'
  end

  test 'should update sco' do
    put :update, id: @sco, 
      sco: Fabricate.attributes_for(:sco)
    assert_redirected_to configs_scos_url
  end

  test 'should destroy sco' do
    assert_difference('Sco.count', -1) do
      delete :destroy, id: @sco
    end

    assert_redirected_to configs_scos_path
  end
end
