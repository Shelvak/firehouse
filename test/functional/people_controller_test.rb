require 'test_helper'

class PeopleControllerTest < ActionController::TestCase

  setup do
    @person = Fabricate(:person)
    @user = Fabricate(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:people)
    assert_select '#unexpected_error', false
    assert_template "people/index"
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:person)
    assert_select '#unexpected_error', false
    assert_template "people/new"
  end

  test "should create person" do
    assert_difference('Person.count') do
      post :create, person: Fabricate.attributes_for(:person)
    end

    assert_redirected_to person_url(assigns(:person))
  end

  test "should show person" do
    get :show, id: @person
    assert_response :success
    assert_not_nil assigns(:person)
    assert_select '#unexpected_error', false
    assert_template "people/show"
  end

  test "should get edit" do
    get :edit, id: @person
    assert_response :success
    assert_not_nil assigns(:person)
    assert_select '#unexpected_error', false
    assert_template "people/edit"
  end

  test "should update person" do
    put :update, id: @person, 
      person: Fabricate.attributes_for(:person, attr: 'value')
    assert_redirected_to person_url(assigns(:person))
  end

  test "should destroy person" do
    assert_difference('Person.count', -1) do
      delete :destroy, id: @person
    end

    assert_redirected_to people_path
  end
end
