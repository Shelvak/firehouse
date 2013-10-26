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
        assert @mobile_intervention.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @mobile_intervention.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('MobileIntervention.count', -1) { @mobile_intervention.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @mobile_intervention.attr = ''
    
    assert @mobile_intervention.invalid?
    assert_equal 1, @mobile_intervention.errors.size
    assert_equal [error_message_from_model(@mobile_intervention, :attr, :blank)],
      @mobile_intervention.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_mobile_intervention = Fabricate(:mobile_intervention)
    @mobile_intervention.attr = new_mobile_intervention.attr

    assert @mobile_intervention.invalid?
    assert_equal 1, @mobile_intervention.errors.size
    assert_equal [error_message_from_model(@mobile_intervention, :attr, :taken)],
      @mobile_intervention.errors[:attr]
  end
end
