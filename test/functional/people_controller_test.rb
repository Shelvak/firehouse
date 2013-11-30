require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  setup do
    # TODO : Mejorar building - Vehicle relación con persona/mobile_intervention
    @person = Fabricate(:person)
    @building = @person.building
    @mobile_intervention = @building.mobile_intervention
    @mobile_intervention.vehicles << [@person.vehicle]
    @vehicle = @mobile_intervention.vehicles.sample
    @endowment = @mobile_intervention.endowment
    @intervention = @endowment.intervention
    @user = Fabricate(:user)
    sign_in @user
  end

  test 'should get new for building' do
    xhr :get, :new, intervention_id: @intervention.to_param,
        endowment_id: @endowment.to_param,
        building_id: @building.to_param
    assert_response :success
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_not_nil assigns(:person)
    assert_equal assigns(:building), assigns(:type)
    assert_select '#unexpected_error', false
    assert_template ['people/_new', 'people/_form']
  end

  test 'should create person for building' do
    assert_difference('Person.count') do
      xhr :post, :create, intervention_id: @intervention.to_param,
          endowment_id: @endowment.to_param,
          building_id: @building.to_param,
          person: Fabricate.attributes_for(:person)
    end
    assert_response :success
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_equal @building.people.last, assigns(:person)
    assert_select '#unexpected_error', false
    assert_template 'mobile_interventions/_person'
  end

  test 'should get edit for building' do
    xhr :get, :edit, intervention_id: @intervention.to_param,
        endowment_id: @endowment.to_param,
        building_id: @building.to_param,
        id: @person
    assert_response :success
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_not_nil assigns(:person)
    assert_equal assigns(:building), assigns(:type)
    assert_select '#unexpected_error', false
    assert_template ['people/_edit', 'people/_form']
  end

  test 'should update person for building' do
    xhr :put, :update, intervention_id: @intervention.to_param,
        endowment_id: @endowment.to_param,
        building_id: @building.to_param,
        id: @person, person: Fabricate.attributes_for(:person, name: 'value')
    assert_response :success
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_not_nil assigns(:building)

    assert_equal assigns(:person), Person.last
    assert_select '#unexpected_error', false
    assert_template 'mobile_interventions/_person'
  end

  test 'should destroy person for building' do
    assert_difference('Person.count', -1) do
      xhr :delete, :destroy, intervention_id: @intervention.to_param,
          endowment_id: @endowment.to_param,
          building_id: @building.to_param,
          id: @person
    end
    assert_response :success
    assert_template ['mobile_interventions/_building',
                     'mobile_interventions/_people_table']
  end

  test 'should get new for vehicle' do
    xhr :get, :new, intervention_id: @intervention.to_param,
        endowment_id: @endowment.to_param,
        vehicle_id: @vehicle.to_param
    assert_response :success
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_not_nil assigns(:person)
    assert_equal assigns(:vehicle), assigns(:type)
    assert_select '#unexpected_error', false
    assert_template ['people/_new', 'people/_form']
  end

  test 'should create person for vehicle' do
    assert_difference('Person.count') do
      xhr :post, :create, intervention_id: @intervention.to_param,
        endowment_id: @endowment.to_param,
        vehicle_id: @vehicle.to_param,
        person: Fabricate.attributes_for(:person)
    end

    assert_response :success
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_equal @vehicle.people.last, assigns(:person)
    assert_select '#unexpected_error', false
    assert_template 'mobile_interventions/_person'
  end

  test 'should get edit for vehicle' do
    xhr :get, :edit, intervention_id: @intervention.to_param,
      endowment_id: @endowment.to_param,
      vehicle_id: @vehicle.to_param,
      id: @person

    assert_response :success
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_not_nil assigns(:person)
    assert_equal assigns(:vehicle), assigns(:type)
    assert_select '#unexpected_error', false
    assert_template ['people/_edit', 'people/_form']
  end

  test 'should update person for vehicle' do
    xhr :put, :update, intervention_id: @intervention.to_param,
        endowment_id: @endowment.to_param,
        vehicle_id: @vehicle.to_param,
        id: @person, person: Fabricate.attributes_for(:person, name: 'value')
    assert_response :success
    assert_not_nil assigns(:intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:mobile_intervention)
    assert_not_nil assigns(:vehicle)

    assert_equal assigns(:person), Person.last
    assert_select '#unexpected_error', false
    assert_template 'mobile_interventions/_person'
  end

  test 'should destroy person for vehicle' do
    assert_difference('Person.count', -1) do
      xhr :delete, :destroy, intervention_id: @intervention.to_param,
          endowment_id: @endowment.to_param,
          vehicle_id: @vehicle.to_param,
          id: @person
    end
    assert_response :success
    assert_template ['mobile_interventions/_vehicle',
                     'mobile_interventions/_people_table']
  end
end
