require 'test_helper'

class MobileInterventionsControllerTest < ActionController::TestCase

  setup do
    @mobile_intervention = Fabricate(:mobile_intervention)
    @endowment = @mobile_intervention.endowment
    @intervention = @endowment.intervention
    @user = Fabricate(:user)
    sign_in @user
  end

  test 'should show mobile_intervention' do
    get :show, endowment_id: @endowment.to_param,
        intervention_id: @intervention.to_param,
        id: @mobile_intervention
    assert_response :success
    assert_not_nil assigns(:mobile_intervention)
    assert_not_nil assigns(:endowment)
    assert_not_nil assigns(:intervention)
    assert_select '#unexpected_error', false
    assert_template 'mobile_interventions/show'
  end

  test 'should update mobile_intervention' do
    put :update, endowment_id: @endowment.to_param,
        intervention_id: @intervention.to_param,
        id: @mobile_intervention,
        mobile_intervention: Fabricate.attributes_for(:mobile_intervention,
                                                      observations: 'value')
    assert_redirected_to intervention_endowment_mobile_intervention_url(
                             assigns(:intervention),
                             assigns(:endowment))
  end
end
