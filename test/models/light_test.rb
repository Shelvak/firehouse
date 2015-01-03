require 'test_helper'

class LightTest < ActiveSupport::TestCase
  def setup
    @light = Fabricate(:light)
  end

  test 'create' do
    assert_difference ['Light.count', 'PaperTrail::Version.count'] do
      @light = Light.create(Fabricate.attributes_for(:light))
    end 
  end
    
  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Light.count' do
        assert @light.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @light.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Light.count', -1) { @light.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @light.attr = ''
    
    assert @light.invalid?
    assert_equal 1, @light.errors.size
    assert_equal [error_message_from_model(@light, :attr, :blank)],
      @light.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_light = Fabricate(:light)
    @light.attr = new_light.attr

    assert @light.invalid?
    assert_equal 1, @light.errors.size
    assert_equal [error_message_from_model(@light, :attr, :taken)],
      @light.errors[:attr]
  end
end
