require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  def setup
    @shift = Fabricate(:shift)
  end

  test 'create' do
    assert_difference ['Shift.count', 'PaperTrail::Version.count'] do
      Shift.create!(
        Fabricate.attributes_for(:shift, firefighter_id: @shift.firefighter_id)
      )
    end
  end

  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Shift.count' do
        assert @shift.update_attributes(notes: 'Updated')
      end
    end

    assert_equal 'Updated', @shift.reload.notes
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Shift.count', -1) { @shift.destroy }
    end
  end

  test 'validates blank attributes' do
    @shift = Shift.new
    @shift.firefighter = nil
    @shift.start_at = nil
    @shift.kind = nil

    assert @shift.invalid?
    assert_equal 3, @shift.errors.size
    [:firefighter, :start_at, :kind].each do |attr|
    assert_equal [error_message_from_model(@shift, attr, :blank)],
      @shift.errors[attr]
    end
  end
end
