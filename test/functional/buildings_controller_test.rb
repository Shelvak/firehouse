require 'test_helper'

class BuildingsControllerTest < ActionController::TestCase

  setup do
    @building = Fabricate(:building)
    @mobile_intervention = @building.mobile_intervention
    @user = Fabricate(:user)
    sign_in @user
  end

  test 'should get new' do
    xhr :get, :new,
        intervention_id: @mobile_intervention.endowment.intervention.to_param,
        endowment_id: @mobile_intervention.endowment.to_param
    assert_response :success
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_not_nil assigns(:building)
    assert_select '#unexpected_error', false
    assert_template :new
    assert_template :form
  end

  test 'should create building' do
    assert_difference('Building.count') do
      xhr :post, :create,
          intervention_id: @mobile_intervention.endowment.intervention.to_param,
          endowment_id: @mobile_intervention.endowment.to_param,
          building: Fabricate.attributes_for(:building)
    end
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_equal assigns(:building), assigns(:mobile_intervention).buildings.last
    assert_response :success
    assert_template 'mobile_interventions/_building'
    assert_template 'mobile_interventions/_people_table'
  end

  test 'should get edit' do
    xhr :get, :edit,
        intervention_id: @mobile_intervention.endowment.intervention.to_param,
        endowment_id: @mobile_intervention.endowment.to_param,
        id: @building
    assert_response :success
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_not_nil assigns(:building)
    assert_select '#unexpected_error', false
    assert_template 'buildings/_edit'
    assert_template 'buildings/_form'
  end

  test 'should update building' do
      xhr :put, :update,
          intervention_id: @mobile_intervention.endowment.intervention.to_param,
          endowment_id: @mobile_intervention.endowment.to_param,
          id: @building,
          building: Fabricate.attributes_for(:building, floor: 'Wood')
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_not_nil assigns(:building)
    assert_response :success
    assert_template 'mobile_interventions/_building'
    assert_template 'mobile_interventions/_people_table'
  end

  test 'should destroy building' do
    xhr :delete, :destroy,
        intervention_id: @mobile_intervention.endowment.intervention.to_param,
        endowment_id: @mobile_intervention.endowment.to_param,
        id: @building
    assert_response :success
    assert_template 'mobile_interventions/_building'
    assert_template 'mobile_interventions/_people_table'
  end
end
