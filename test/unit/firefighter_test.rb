require 'test_helper'

class FirefighterTest < ActiveSupport::TestCase
  def setup
    @firefighter = Fabricate(:firefighter)
  end

  test 'create' do
    assert_difference 'Firefighter.count' do
     assert_difference 'PaperTrail::Version.count', 2 do
       Firefighter.create(Fabricate.attributes_for(:firefighter))
     end
    end
  end

  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Firefighter.count' do
        assert @firefighter.update_attributes(firstname: 'Updated')
      end
    end

    assert_equal 'Updated', @firefighter.reload.firstname
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Firefighter.count', -1) { @firefighter.destroy }
    end
  end

  test 'validates blank attributes' do
    @firefighter.firstname = ''
    @firefighter.lastname = ''
    @firefighter.identification = ''

    assert @firefighter.invalid?
    assert_equal 3, @firefighter.errors.size
    assert_equal [error_message_from_model(@firefighter, :firstname, :blank)],
      @firefighter.errors[:firstname]
    assert_equal [error_message_from_model(@firefighter, :lastname, :blank)],
      @firefighter.errors[:lastname]
    assert_equal [
      error_message_from_model(@firefighter, :identification, :blank)
    ], @firefighter.errors[:identification]
  end

  test 'validates unique attributes' do
    new_firefighter = Fabricate(:firefighter)
    @firefighter.identification = new_firefighter.identification

    assert @firefighter.invalid?
    assert_equal 1, @firefighter.errors.size
    assert_equal [
      error_message_from_model(@firefighter, :identification, :taken)
    ], @firefighter.errors[:identification]
  end
end
