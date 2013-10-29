require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  context 'for an existing building' do
    setup do
      @person = Fabricate(:person)
      @building = @person.building
      @mobile_intervention = @building.mobile_intervention
      @endowment = @mobile_intervention.endowment
      @intervention = @endowment.intervention
      @user = Fabricate(:user)
      sign_in @user
    end

    should 'should get new' do
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

    should 'should create person' do
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

    should 'should get edit' do
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

    should 'should update person' do
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

    should 'should destroy person' do
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
  end

  context 'for an existing vehicle' do
    setup do
      @person = Fabricate(:person)
      @vehicle = @person.vehicle
      @mobile_intervention = @vehicle.mobile_intervention
      @endowment = @mobile_intervention.endowment
      @intervention = @endowment.intervention
      @user = Fabricate(:user)
      sign_in @user
    end

    should 'should get new' do
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

    should 'should create person' do
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

    should 'should get edit' do
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

    should 'should update person' do
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

    should 'should destroy person' do
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
end
