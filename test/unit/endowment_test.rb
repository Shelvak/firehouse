require 'test_helper'

class EndowmentTest < ActiveSupport::TestCase
  def setup
    @endowment = Fabricate(:endowment)
  end

  test 'create' do
    assert_difference ['Endowment.count', 'Version.count'] do
      Endowment.create(Fabricate.attributes_for(:endowment))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Endowment.count' do
        assert @endowment.update_attributes(number: 101)
      end
    end

    assert_equal 101, @endowment.reload.number
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Endowment.count', -1) { @endowment.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @endowment.number = ''
    
    assert @endowment.invalid?
    assert_equal 1, @endowment.errors.size
    assert_equal [error_message_from_model(@endowment, :number, :blank)],
      @endowment.errors[:number]
  end
end
