require 'test_helper'

class VehicleTest < ActiveSupport::TestCase
  def setup
    @vehicle = Fabricate(:vehicle)
  end

  test 'create' do
    assert_difference ['Vehicle.count'] do
      Vehicle.create!(Fabricate.attributes_for(:vehicle))
    end 
  end
    
  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Vehicle.count' do
        assert @vehicle.update_attributes(mark: 'Updated')
      end
    end

    assert_equal 'Updated', @vehicle.reload.mark
  end
    
  test 'destroy' do 
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Vehicle.count', -1) { @vehicle.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @vehicle.damage = ''
    @vehicle.domain = ''

    assert @vehicle.invalid?
    assert_equal 2, @vehicle.errors.size
    assert_equal [error_message_from_model(@vehicle, :damage, :blank)],
      @vehicle.errors[:damage]
    assert_equal [error_message_from_model(@vehicle, :domain, :blank)],
      @vehicle.errors[:domain]
  end
end
