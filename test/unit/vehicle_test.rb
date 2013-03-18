require 'test_helper'

class VehicleTest < ActiveSupport::TestCase
  def setup
    @vehicle = Fabricate(:vehicle)
  end

  test 'create' do
    assert_difference ['Vehicle.count', 'Version.count'] do
      @vehicle = Vehicle.create(Fabricate.attributes_for(:vehicle))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Vehicle.count' do
        assert @vehicle.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @vehicle.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Vehicle.count', -1) { @vehicle.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @vehicle.attr = ''
    
    assert @vehicle.invalid?
    assert_equal 1, @vehicle.errors.size
    assert_equal [error_message_from_model(@vehicle, :attr, :blank)],
      @vehicle.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_vehicle = Fabricate(:vehicle)
    @vehicle.attr = new_vehicle.attr

    assert @vehicle.invalid?
    assert_equal 1, @vehicle.errors.size
    assert_equal [error_message_from_model(@vehicle, :attr, :taken)],
      @vehicle.errors[:attr]
  end
end
