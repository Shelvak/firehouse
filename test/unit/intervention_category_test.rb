require 'test_helper'

class InterventionCategoryTest < ActiveSupport::TestCase
  def setup
    @intervention_category = Fabricate(:intervention_category)
  end

  test 'create' do
    assert_difference ['InterventionCategory.count', 'Version.count'] do
      @intervention_category = InterventionCategory.create(Fabricate.attributes_for(:intervention_category))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'InterventionCategory.count' do
        assert @intervention_category.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @intervention_category.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('InterventionCategory.count', -1) { @intervention_category.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @intervention_category.attr = ''
    
    assert @intervention_category.invalid?
    assert_equal 1, @intervention_category.errors.size
    assert_equal [error_message_from_model(@intervention_category, :attr, :blank)],
      @intervention_category.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_intervention_category = Fabricate(:intervention_category)
    @intervention_category.attr = new_intervention_category.attr

    assert @intervention_category.invalid?
    assert_equal 1, @intervention_category.errors.size
    assert_equal [error_message_from_model(@intervention_category, :attr, :taken)],
      @intervention_category.errors[:attr]
  end
end
