require 'test_helper'

class ScoTest < ActiveSupport::TestCase
  def setup
    @sco = Fabricate(:sco)
  end

  test 'create' do
    assert_difference ['Sco.count', 'PaperTrail::Version.count'] do
      @sco = Sco.create(Fabricate.attributes_for(:sco))
    end 
  end
    
  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Sco.count' do
        assert @sco.update_attributes(full_name: 'Updated')
      end
    end

    assert_equal 'Updated', @sco.reload.full_name
  end
    
  test 'destroy' do 
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Sco.count', -1) { @sco.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @sco.full_name = ''
    
    assert @sco.invalid?
    assert_equal 1, @sco.errors.size
    assert_equal [error_message_from_model(@sco, :full_name, :blank)],
      @sco.errors[:full_name]
  end
end
