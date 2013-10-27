require 'test_helper'

class MobileInterventionTest < ActiveSupport::TestCase
  def setup
    @mobile_intervention = Fabricate(:mobile_intervention)
  end

  test 'create' do
    assert_difference ['MobileIntervention.count'] do
      @mobile_intervention = MobileIntervention.create(Fabricate.attributes_for(:mobile_intervention))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'MobileIntervention.count' do
        assert @mobile_intervention.update_attributes(observations: 'Nothing new')
      end
    end

    assert_equal 'Nothing new', @mobile_intervention.reload.observations
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('MobileIntervention.count', -1) { @mobile_intervention.destroy }
    end
  end
end
