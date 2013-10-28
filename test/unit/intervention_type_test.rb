require 'test_helper'

class InterventionTypeTest < ActiveSupport::TestCase
  def setup
    @intervention_type = Fabricate(:intervention_type)
  end

  test 'create' do
    assert_difference ['InterventionType.count', 'Version.count'] do
      @intervention_type = InterventionType.create(Fabricate.attributes_for(:intervention_type))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'InterventionType.count' do
        assert @intervention_type.update_attributes(name: 'Explosion')
      end
    end

    assert_equal 'Explosion', @intervention_type.reload.name
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('InterventionType.count', -1) { @intervention_type.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @intervention_type.name = ''
    @intervention_type.color = ''

    assert @intervention_type.invalid?
    assert_equal 2, @intervention_type.errors.size
    assert_equal [error_message_from_model(@intervention_type, :name, :blank)],
      @intervention_type.errors[:name]
    assert_equal [error_message_from_model(@intervention_type, :color, :blank)],
      @intervention_type.errors[:color]
  end
end
