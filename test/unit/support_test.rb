require 'test_helper'

class SupportTest < ActiveSupport::TestCase
  def setup
    @support = Fabricate(:support)
  end

  test 'create' do
    assert_difference ['Support.count'] do
      Support.create!(Fabricate.attributes_for(:support))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Support.count' do
        assert @support.update_attributes(responsible: 'Updated')
      end
    end

    assert_equal 'Updated', @support.reload.responsible
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Support.count', -1) { @support.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @support.support_type = ''
    @support.responsible = ''
    @support.owner = ''

    assert @support.invalid?
    assert_equal 3, @support.errors.size
    assert_equal [error_message_from_model(@support, :support_type, :blank)],
      @support.errors[:support_type]
    assert_equal [error_message_from_model(@support, :responsible, :blank)],
      @support.errors[:responsible]
    assert_equal [error_message_from_model(@support, :owner, :blank)],
      @support.errors[:owner]
  end
end
