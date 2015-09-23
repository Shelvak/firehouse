require 'test_helper'

class Configs::RelativesControllerTest < ActionController::TestCase

  setup do
    @relative = Fabricate(:relative)
    @user = Fabricate(:user)
    sign_in @user
  end

  test 'should get new' do
    xhr :get, :new, firefighter_id: @relative.firefighter.id
    assert_response :success
    assert_not_nil assigns(:relative)
    assert_select '#unexpected_error', false
    assert_template 'configs/relatives/_new'
  end

  test 'should create relative' do
    assert_difference('Relative.count') do
      xhr :post, :create, firefighter_id: @relative.firefighter.id, relative: Fabricate.attributes_for(:relative)
    end
    assert_response :success
    assert_not_nil assigns(:relative)
    assert_template 'configs/relatives/_relative'
    assert_select '#unexpected_error', false
  end

  test 'should get edit' do
    xhr :get, :edit, firefighter_id: @relative.firefighter.id, id: @relative
    assert_response :success
    assert_not_nil assigns(:relative)
    assert_select '#unexpected_error', false
    assert_template 'configs/relatives/_edit'
  end

  test 'should update relative' do
    xhr :put, :update, firefighter_id: @relative.firefighter.id, id: @relative, relative: { last_name: 'lastName' }

    assert_response :success
    assert_not_nil assigns(:relative)
    assert_template 'configs/relatives/_relative'
    assert_select '#unexpected_error', false
  end

  test 'should destroy relative' do
    assert_difference('Relative.count', -1) do
      xhr :delete, :destroy, firefighter_id: @relative.firefighter.id, id: @relative
    end
    assert_response :success
  end
end
