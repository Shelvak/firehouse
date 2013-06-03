require 'test_helper'

class BuildingTest < ActiveSupport::TestCase
  def setup
    @building = Fabricate(:building)
  end

  test 'create' do
    assert_difference ['Building.count', 'Version.count'] do
      @building = Building.create(Fabricate.attributes_for(:building))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Building.count' do
        assert @building.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @building.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Building.count', -1) { @building.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @building.attr = ''
    
    assert @building.invalid?
    assert_equal 1, @building.errors.size
    assert_equal [error_message_from_model(@building, :attr, :blank)],
      @building.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_building = Fabricate(:building)
    @building.attr = new_building.attr

    assert @building.invalid?
    assert_equal 1, @building.errors.size
    assert_equal [error_message_from_model(@building, :attr, :taken)],
      @building.errors[:attr]
  end
end
