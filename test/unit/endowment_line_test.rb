require 'test_helper'

class EndowmentLineTest < ActiveSupport::TestCase
  def setup
    @endowment_line = Fabricate(:endowment_line)
  end

  test 'create' do
    assert_difference ['EndowmentLine.count', 'Version.count'] do
      EndowmentLine.create(Fabricate.attributes_for(
        :endowment_line, 
        endowment_id: @endowment_line.endowment_id,
        firefighter_id: @endowment_line.firefighter_id
      ))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'EndowmentLine.count' do
        assert @endowment_line.update_attributes(charge: 'Updated')
      end
    end

    assert_equal 'Updated', @endowment_line.reload.charge
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('EndowmentLine.count', -1) { @endowment_line.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @endowment_line.charge = ''
    @endowment_line.firefighter_id = ''
    
    assert @endowment_line.invalid?
    assert_equal 2, @endowment_line.errors.size
    assert_equal [error_message_from_model(@endowment_line, :charge, :blank)],
      @endowment_line.errors[:charge]
    assert_equal [
      error_message_from_model(@endowment_line, :firefighter_id, :blank)
    ], @endowment_line.errors[:firefighter_id]
  end
end
