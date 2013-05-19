require 'test_helper'

class EndowmentLineTest < ActiveSupport::TestCase
  def setup
    intervention = Fabricate(:intervention)
    @endowment_line = intervention.endowments.sample.endowment_lines.sample
  end

  test 'create' do
    assert_difference ['EndowmentLine.count', 'Version.count'] do
      endowment_line = EndowmentLine.new(Fabricate.attributes_for(
        :endowment_line
      ))
      endowment_line.firefighter_ids << @endowment_line.firefighters.map(&:id)
      endowment_line.endowment_id = @endowment_line.endowment_id
      endowment_line.save
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'EndowmentLine.count' do
        assert @endowment_line.update_attributes(charge: 99)
      end
    end

    assert_equal 99, @endowment_line.reload.charge
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('EndowmentLine.count', -1) { @endowment_line.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @endowment_line.charge = ''
    
    assert @endowment_line.invalid?
    assert_equal 1, @endowment_line.errors.size
    assert_equal [error_message_from_model(@endowment_line, :charge, :blank)],
      @endowment_line.errors[:charge]
  end
end
