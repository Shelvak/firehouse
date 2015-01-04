require 'test_helper'

class SupportsControllerTest < ActionController::TestCase
  setup do
    @support = Fabricate(:support)
    @mobile_intervention = @support.mobile_intervention
    @endowment = @mobile_intervention.endowment
    @intervention = @endowment.intervention
    @user = Fabricate(:user)
    sign_in @user
  end

  test 'should get new' do
    xhr :get, :new,
        intervention_id: @intervention.to_param,
        endowment_id: @endowment.to_param
    assert_response :success
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_not_nil assigns(:support)
    assert_select '#unexpected_error', false
    assert_template 'supports/_new'
    assert_template 'supports/_form'
  end

  test 'should create support' do
    assert_difference('Support.count') do
      xhr :post, :create,
          intervention_id: @intervention.to_param,
          endowment_id: @endowment.to_param,
          support: Fabricate.attributes_for(:support)
    end
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_equal assigns(:support), assigns(:mobile_intervention).supports.last
    assert_response :success
    assert_template 'mobile_interventions/_support'
  end

  test 'should get edit' do
    xhr :get, :edit,
        intervention_id: @mobile_intervention.endowment.intervention.to_param,
        endowment_id: @mobile_intervention.endowment.to_param,
        id: @support
    assert_response :success
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_not_nil assigns(:support)
    assert_select '#unexpected_error', false
    assert_template 'supports/_edit'
    assert_template 'supports/_form'
  end

  test 'should update building' do
      xhr :put, :update,
          intervention_id: @mobile_intervention.endowment.intervention.to_param,
          endowment_id: @mobile_intervention.endowment.to_param,
          id: @support,
          support: Fabricate.attributes_for(:support, responsible: 'No, not me again')
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_not_nil assigns(:support)
    assert_response :success
    assert_template 'mobile_interventions/_support'
  end

  test 'should destroy building' do
    xhr :delete, :destroy,
        intervention_id: @mobile_intervention.endowment.intervention.to_param,
        endowment_id: @mobile_intervention.endowment.to_param,
        id: @support
    assert_response :success
    assert_template nil
  end
end
