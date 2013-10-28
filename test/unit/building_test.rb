require 'test_helper'

class BuildingTest < ActiveSupport::TestCase
  def setup
    @building = Fabricate(:building)
  end

  test 'create' do
    assert_difference ['Building.count'] do
      @building = Building.create(Fabricate.attributes_for(:building))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Building.count' do
        assert @building.update_attributes(address: 'alwaysalive 123')
      end
    end

    assert_equal 'alwaysalive 123', @building.reload.address
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Building.count', -1) { @building.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @building.address = ''
    
    assert @building.invalid?
    assert_equal 1, @building.errors.size
    assert_equal [error_message_from_model(@building, :address, :blank)],
      @building.errors[:address]
  end
end
