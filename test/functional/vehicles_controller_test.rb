require 'test_helper'

class VehiclesControllerTest < ActionController::TestCase
  setup do
    @vehicle = Fabricate(:vehicle)
    @mobile_intervention = @vehicle.mobile_intervention
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
    assert_not_nil assigns(:vehicle)
    assert_select '#unexpected_error', false
    assert_template ['vehicles/new', 'vehicles/form']
  end

  test 'should create vehicle' do
    assert_difference('Vehicle.count') do
      xhr :post, :create,
          intervention_id: @mobile_intervention.endowment.intervention.to_param,
          endowment_id: @mobile_intervention.endowment.to_param,
          vehicle: Fabricate.attributes_for(:vehicle)
    end
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_equal assigns(:vehicle), assigns(:mobile_intervention).vehicles.last
    assert_response :success
    assert_template ['mobile_interventions/_vehicle',
                     'mobile_interventions/_people_table']
  end

  test 'should get edit' do
    xhr :get, :edit,
        intervention_id: @mobile_intervention.endowment.intervention.to_param,
        endowment_id: @mobile_intervention.endowment.to_param,
        id: @vehicle
    assert_response :success
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_not_nil assigns(:vehicle)
    assert_select '#unexpected_error', false
    assert_template ['vehicles/_edit', 'vehicles/_form']
  end

  test 'should update vehicle' do
    xhr :put, :update,
        intervention_id: @mobile_intervention.endowment.intervention.to_param,
        endowment_id: @mobile_intervention.endowment.to_param,
        id: @vehicle,
        vehicle: Fabricate.attributes_for(:vehicle, mark: 'Chevy')
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_not_nil assigns(:vehicle)
    assert_response :success
    assert_template ['mobile_interventions/_vehicle',
                     'mobile_interventions/_people_table']
  end

  test 'should destroy building' do
    xhr :delete, :destroy,
        intervention_id: @mobile_intervention.endowment.intervention.to_param,
        endowment_id: @mobile_intervention.endowment.to_param,
        id: @vehicle
    assert_response :success
    assert_template ['mobile_interventions/_vehicle',
                     'mobile_interventions/_people_table']
  end
end
