require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  def setup
    @shift = Fabricate(:shift)
  end

  test 'create' do
    assert_difference ['Shift.count', 'PaperTrail::Version.count'] do
      @shift = Shift.create(Fabricate.attributes_for(:shift))
    end 
  end
    
  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Shift.count' do
        assert @shift.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @shift.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Shift.count', -1) { @shift.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @shift.attr = ''
    
    assert @shift.invalid?
    assert_equal 1, @shift.errors.size
    assert_equal [error_message_from_model(@shift, :attr, :blank)],
      @shift.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_shift = Fabricate(:shift)
    @shift.attr = new_shift.attr

    assert @shift.invalid?
    assert_equal 1, @shift.errors.size
    assert_equal [error_message_from_model(@shift, :attr, :taken)],
      @shift.errors[:attr]
  end
end
