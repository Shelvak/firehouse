require 'test_helper'

class TruckTest < ActiveSupport::TestCase
  def setup
    @truck = Fabricate(:truck)
  end

  test 'create' do
    assert_difference ['Truck.count', 'PaperTrail::Version.count'] do
      @truck = Truck.create(Fabricate.attributes_for(:truck))
    end 
  end
    
  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Truck.count' do
        assert @truck.update_attributes(mileage: 99)
      end
    end

    assert_equal 99, @truck.reload.mileage
  end
    
  test 'destroy' do 
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Truck.count', -1) { @truck.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @truck.number = ''
    
    assert @truck.invalid?
    assert_equal 1, @truck.errors.size
    assert_equal [error_message_from_model(@truck, :number, :blank)],
      @truck.errors[:number]
  end
    
  test 'validates unique attributes' do
    new_truck = Fabricate(:truck)
    @truck.number = new_truck.number

    assert @truck.invalid?
    assert_equal 1, @truck.errors.size
    assert_equal [error_message_from_model(@truck, :number, :taken)],
      @truck.errors[:number]
  end
end
