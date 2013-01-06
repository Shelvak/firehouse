require 'test_helper'

class InterventionTest < ActiveSupport::TestCase
  def setup
    @intervention = Fabricate(:intervention)
  end

  test 'create' do
    assert_difference ['Intervention.count', 'Version.count'] do
      @intervention = Intervention.create(
        Fabricate.attributes_for(
          :intervention, receptor_id: @intervention.receptor_id,
          sco_id: @intervention.sco_id, truck_id: @intervention.truck_id
        )
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

  test 'validate truck out-in distance' do
    @intervention.out_mileage = 10
    @intervention.arrive_mileage = 9
    @intervention.back_mileage = 9
    @intervention.in_mileage = 9
    error = [I18n.t(
      'validations.distance.must_be_greater_than', distance: 10
    )]

    assert @intervention.invalid?
    assert_equal 3, @intervention.errors.size
    assert_equal error, @intervention.errors[:arrive_mileage]
    assert_equal error, @intervention.errors[:back_mileage]
    assert_equal error, @intervention.errors[:in_mileage]

    @intervention.reload

    @intervention.out_mileage = 10
    @intervention.arrive_mileage = 12
    @intervention.back_mileage = 11
    @intervention.in_mileage = 11
    error = [I18n.t(
      'validations.distance.must_be_greater_than', distance: 12
    )]

    assert @intervention.invalid?
    assert_equal 2, @intervention.errors.size
    assert_equal error, @intervention.errors[:back_mileage]
    assert_equal error, @intervention.errors[:in_mileage]

    @intervention.reload

    @intervention.out_mileage = 10
    @intervention.arrive_mileage = 11
    @intervention.back_mileage = 13
    @intervention.in_mileage = 12

    assert @intervention.invalid?
    assert_equal 1, @intervention.errors.size
    assert_equal [I18n.t(
      'validations.distance.must_be_greater_than', distance: 13
    )], @intervention.errors[:in_mileage]
  end
end
