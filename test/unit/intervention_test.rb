require 'test_helper'

class InterventionTest < ActiveSupport::TestCase
  def setup
    @intervention = Fabricate(:intervention)
  end

  test 'create' do
    assert_difference 'Intervention.count' do
      # Versions = 10 firefighter, 6*endow_line, endowment, intervention, truck
      assert_difference 'Version.count', 10 do
        Intervention.create!(
          Fabricate.attributes_for(
            :intervention,
            receptor_id: @intervention.receptor_id,
            intervention_type_id: @intervention.intervention_type_id,
            sco_id: @intervention.sco_id
          )
        )
      end
    end
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Intervention.count' do
        assert @intervention.update_attributes(address: 'Updated')
      end
    end

    assert_equal 'Updated', @intervention.reload.address
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Intervention.count', -1) { @intervention.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @intervention.address = ''
    @intervention.receptor_id = ''
    
    assert @intervention.invalid?
    assert_equal 2, @intervention.errors.size
    assert_equal [error_message_from_model(@intervention, :address, :blank)],
      @intervention.errors[:address]
    assert_equal [error_message_from_model(@intervention, :receptor_id, :blank)],
      @intervention.errors[:receptor_id]
  end
end
