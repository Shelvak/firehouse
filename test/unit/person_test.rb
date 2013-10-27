require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  def setup
    @person = Fabricate(:person)
  end

  test 'create' do
    assert_difference ['Person.count'] do
      @person = Person.create(Fabricate.attributes_for(:person))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Person.count' do
        assert @person.update_attributes(name: 'Updated')
      end
    end

    assert_equal 'Updated', @person.reload.name
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Person.count', -1) { @person.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @person.name = ''
    
    assert @person.invalid?
    assert_equal 1, @person.errors.size
    assert_equal [error_message_from_model(@person, :name, :blank)],
      @person.errors[:name]
  end
end
