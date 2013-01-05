require 'test_helper'

class InterventionTest < ActiveSupport::TestCase
  def setup
    @intervention = Fabricate(:intervention)
  end

  test 'create' do
    assert_difference ['Intervention.count', 'Version.count'] do
      @intervention = Intervention.create(
        Fabricate.attributes_for(:intervention, receptor_id: @intervention.receptor_id)
      )
    end
  end
    
  test 'update' do
    assert_difference 'Version.count' do
      assert_no_difference 'Intervention.count' do
        assert @intervention.update_attributes(address: 'Updated')
      end
    end

    assert_equal 'Updated', @intervention.reload.address
  end
    
  test 'destroy' do 
    assert_difference 'Version.count' do
      assert_difference('Intervention.count', -1) { @intervention.destroy }
    end
  end
    
  test 'validates blank attributes' do
    @intervention.address = ''
    @intervention.kind = ''
    @intervention.number = ''
    @intervention.receptor_id = ''
    
    assert @intervention.invalid?
    assert_equal 4, @intervention.errors.size
    assert_equal [error_message_from_model(@intervention, :address, :blank)],
      @intervention.errors[:address]
    assert_equal [error_message_from_model(@intervention, :kind, :blank)],
      @intervention.errors[:kind]
    assert_equal [error_message_from_model(@intervention, :number, :blank)],
      @intervention.errors[:number]
    assert_equal [error_message_from_model(@intervention, :receptor_id, :blank)],
      @intervention.errors[:receptor_id]
  end
    
  test 'validates unique attributes' do
    new_intervention = Fabricate(:intervention)
    @intervention.number = new_intervention.number

    assert @intervention.invalid?
    assert_equal 1, @intervention.errors.size
    assert_equal [error_message_from_model(@intervention, :number, :taken)],
      @intervention.errors[:number]
  end

  test 'validate truck out-in time' do
    @intervention.out_at = 10.minutes.ago
    @intervention.arrive_at = 11.minutes.ago
    @intervention.back_at = 11.minutes.ago
    @intervention.in_at = 11.minutes.ago
    error = [I18n.t(
      'validations.date.must_be_after', date: I18n.l(10.minutes.ago, format: :minimal)
    )]

    assert @intervention.invalid?
    assert_equal 3, @intervention.errors.size
    assert_equal error, @intervention.errors[:arrive_at]
    assert_equal error, @intervention.errors[:back_at]
    assert_equal error, @intervention.errors[:in_at]

    @intervention.reload

    @intervention.out_at = 10.minutes.ago
    @intervention.arrive_at = 8.minutes.ago
    @intervention.back_at = 9.minutes.ago
    @intervention.in_at = 9.minutes.ago
    error = [I18n.t(
      'validations.date.must_be_after', date: I18n.l(8.minutes.ago, format: :minimal)
    )]

    assert @intervention.invalid?
    assert_equal 2, @intervention.errors.size
    assert_equal error, @intervention.errors[:back_at]
    assert_equal error, @intervention.errors[:in_at]

    @intervention.reload

    @intervention.out_at = 10.minutes.ago
    @intervention.arrive_at = 9.minutes.ago
    @intervention.back_at = 7.minutes.ago
    @intervention.in_at = 8.minutes.ago

    assert @intervention.invalid?
    assert_equal 1, @intervention.errors.size
    assert_equal [I18n.t(
      'validations.date.must_be_after', date: I18n.l(7.minutes.ago, format: :minimal)
    )], @intervention.errors[:in_at]
  end
end
