require 'test_helper'

class InformerTest < ActiveSupport::TestCase
  def setup
    @informer = Fabricate(:informer)
  end

  test 'create' do
    assert_difference ['Informer.count', 'PaperTrail::Version.count'] do
      @informer = Informer.create(Fabricate.attributes_for(
        :informer, intervention_id: @informer.intervention_id
      ))
    end 
  end
    
  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Informer.count' do
        assert @informer.update_attributes(full_name: 'Updated')
      end
    end

    assert_equal 'Updated', @informer.reload.full_name
  end
    
  test 'destroy' do 
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Informer.count', -1) { @informer.destroy }
    end
  end
end
