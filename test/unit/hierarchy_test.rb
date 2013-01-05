require 'test_helper'

class HierarchyTest < ActiveSupport::TestCase
  def setup
    @hierarchy = Fabricate(:hierarchy)
  end

  test 'create' do
    assert_difference ['Hierarchy.count', 'Version.count'] do
      @hierarchy = Hierarchy.create(Fabricate.attributes_for(:hierarchy))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Hierarchy.count' do
        assert @hierarchy.update_attributes(name: 'Updated')
      end
    end

    assert_equal 'Updated', @hierarchy.reload.name
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Hierarchy.count', -1) { @hierarchy.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @hierarchy.name = ''
    
    assert @hierarchy.invalid?
    assert_equal 1, @hierarchy.errors.size
    assert_equal [error_message_from_model(@hierarchy, :name, :blank)],
      @hierarchy.errors[:name]
  end
end
