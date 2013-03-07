require 'test_helper'

class EndowmentsControllerTest < ActionController::TestCase

  setup do
    @endowment = Fabricate(:endowment)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:endowments)
    assert_select '#unexpected_error', false
    assert_template "endowments/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:endowment)
    assert_select '#unexpected_error', false
    assert_template "endowments/new"
  end

  test "should create endowment" do
    assert_difference('Endowment.count') do
      post :create, endowment: Fabricate.attributes_for(:endowment)
    end

    assert_redirected_to endowment_url(assigns(:endowment))
  end

  test "should show endowment" do
    get :show, id: @endowment
    assert_response :success
    assert_not_nil assigns(:endowment)
    assert_select '#unexpected_error', false
    assert_template "endowments/show"
  end

  test "should get edit" do
    get :edit, id: @endowment
    assert_response :success
    assert_not_nil assigns(:endowment)
    assert_select '#unexpected_error', false
    assert_template "endowments/edit"
  end

  test "should update endowment" do
    put :update, id: @endowment, endowment: { number: 101 }
    assert_redirected_to endowment_url(assigns(:endowment))
  end

  test "should destroy endowment" do
    assert_difference('Endowment.count', -1) do
      delete :destroy, id: @endowment
    end

    assert_redirected_to endowments_url
  end
end
