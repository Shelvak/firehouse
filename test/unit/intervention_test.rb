require 'test_helper'

class InterventionTest < ActiveSupport::TestCase
  def setup
    @intervention = Fabricate(:intervention)
  end

  test 'create' do
    assert_difference 'Intervention.count' do
      # PaperTrail::Versions = 10 firefighter, 6*endow_line, endowment, intervention, truck
      assert_difference 'PaperTrail::Version.count', 10 do
        Intervention.create!(
          Fabricate.attributes_for(
            :intervention,
            receptor_id: @intervention.receptor_id,
            intervention_type_id: @intervention.intervention_type_id,
            sco_name: Faker::Name.name
          )
        )
      end
    end
  end

  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Intervention.count' do
        assert @intervention.update_attributes(address: 'Updated')
      end
    end

    assert_equal 'Updated', @intervention.reload.address
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Intervention.count', -1) { @intervention.destroy }
    end
  end

  test 'validates blank attributes' do
    @intervention.intervention_type_id = ''

    assert @intervention.invalid?
    assert_equal 1, @intervention.errors.size
    assert_equal [error_message_from_model(@intervention, :intervention_type_id, :blank)],
      @intervention.errors[:intervention_type_id]
  end
end
