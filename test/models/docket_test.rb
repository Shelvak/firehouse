require 'test_helper'

class DocketTest < ActiveSupport::TestCase
  def setup
    @docket = Fabricate(:docket)
  end

  test 'create' do
    assert_difference ['Docket.count', 'PaperTrail::Version.count'] do
      @docket = Docket.create(Fabricate.attributes_for(:docket))
    end 
  end
    
  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Docket.count' do
        assert @docket.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @docket.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Docket.count', -1) { @docket.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @docket.attr = ''
    
    assert @docket.invalid?
    assert_equal 1, @docket.errors.size
    assert_equal [error_message_from_model(@docket, :attr, :blank)],
      @docket.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_docket = Fabricate(:docket)
    @docket.attr = new_docket.attr

    assert @docket.invalid?
    assert_equal 1, @docket.errors.size
    assert_equal [error_message_from_model(@docket, :attr, :taken)],
      @docket.errors[:attr]
  end
end
