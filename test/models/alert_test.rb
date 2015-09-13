require 'test_helper'

class AlertTest < ActiveSupport::TestCase
  def setup
    @alert = Fabricate(:alert)
  end

  test 'create' do
    assert_difference 'Alert.count' do
      Alert.create!(
        Fabricate.attributes_for(
          :alert, intervention_id: @alert.intervention_id
        )
      )
    end
  end

  test 'destroy' do
    assert_difference('Alert.count', -1) { @alert.destroy }
  end
end
