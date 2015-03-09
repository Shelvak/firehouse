require 'test_helper'

class LightTest < ActiveSupport::TestCase
  def setup
    @light = Fabricate(:light)
  end

  test 'create' do
    assert_difference ['Light.count', 'PaperTrail::Version.count'] do
      Light.create!(Fabricate.attributes_for(:light))
    end
  end

  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Light.count' do
        assert @light.update_attributes(color: 'blusito')
      end
    end

    assert_equal 'blusito', @light.reload.color
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Light.count', -1) { @light.destroy }
    end
  end

  test 'validates blank attributes' do
    @light.kind      = ''
    @light.color     = ''
    @light.intensity = ''

    assert @light.invalid?
    assert_equal 3, @light.errors.size
    [:kind, :color, :intensity].each do |attr|
      assert_equal [error_message_from_model(@light, attr, :blank)],
        @light.errors[attr]
    end
  end
end
