require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  def setup
    @person = Fabricate(:person)
  end

  test 'create' do
    assert_difference ['Person.count', 'Version.count'] do
      @person = Person.create(Fabricate.attributes_for(:person))
    end 
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Person.count' do
        assert @person.update_attributes(attr: 'Updated')
      end
    end

    assert_equal 'Updated', @person.reload.attr
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Person.count', -1) { @person.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @person.attr = ''
    
    assert @person.invalid?
    assert_equal 1, @person.errors.size
    assert_equal [error_message_from_model(@person, :attr, :blank)],
      @person.errors[:attr]
  end
    
  test 'validates unique attributes' do
    new_person = Fabricate(:person)
    @person.attr = new_person.attr

    assert @person.invalid?
    assert_equal 1, @person.errors.size
    assert_equal [error_message_from_model(@person, :attr, :taken)],
      @person.errors[:attr]
  end
end
