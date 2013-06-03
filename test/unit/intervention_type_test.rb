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
        assert @intervention_type.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @intervention_type.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('InterventionType.count', -1) { @intervention_type.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @intervention_type.attr = ''
    
    assert @intervention_type.invalid?
    assert_equal 1, @intervention_type.errors.size
    assert_equal [error_message_from_model(@intervention_type, :attr, :blank)],
      @intervention_type.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_intervention_type = Fabricate(:intervention_type)
    @intervention_type.attr = new_intervention_type.attr

    assert @intervention_type.invalid?
    assert_equal 1, @intervention_type.errors.size
    assert_equal [error_message_from_model(@intervention_type, :attr, :taken)],
      @intervention_type.errors[:attr]
  end
end
