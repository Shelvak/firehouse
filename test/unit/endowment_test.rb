require 'test_helper'

class EndowmentTest < ActiveSupport::TestCase
  def setup
    intervention = Fabricate(:intervention)
    @endowment = intervention.endowments.sample
  end

  test 'create' do
    assert_difference 'Endowment.count' do
      # Firefighter + EndowLine + Endow + Endow-EndowLine-Relation
      assert_difference 'PaperTrail::Version.count', 5 do
        Endowment.create! Fabricate.attributes_for(
          :endowment, truck_id: @endowment.truck_id,
          intervention_id: @endowment.intervention_id
        )
      end
    end
  end

  test 'update' do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Endowment.count' do
        assert @endowment.update_attributes(number: 101)
      end
    end

    assert_equal 101, @endowment.reload.number
  end

  test 'destroy' do
    assert_difference 'PaperTrail::Version.count' do
      assert_difference('Endowment.count', -1) { @endowment.destroy }
    end
  end

  test 'validates blank attributes' do
    @endowment.number = ''

    assert @endowment.invalid?
    assert_equal 1, @endowment.errors.size
    assert_equal [error_message_from_model(@endowment, :number, :not_a_number)],
      @endowment.errors[:number]
  end

  test 'validate truck out-in distance' do
    @endowment.out_mileage = 10
    @endowment.arrive_mileage = 9
    @endowment.back_mileage = 9
    @endowment.in_mileage = 9
    error = [I18n.t(
      'validations.distance.must_be_greater_than', distance: 10
    )]

    assert @endowment.invalid?
    assert_equal 3, @endowment.errors.size
    assert_equal error, @endowment.errors[:arrive_mileage]
    assert_equal error, @endowment.errors[:back_mileage]
    assert_equal error, @endowment.errors[:in_mileage]

    @endowment.reload

    @endowment.out_mileage = 10
    @endowment.arrive_mileage = 12
    @endowment.back_mileage = 11
    @endowment.in_mileage = 11
    error = [I18n.t(
      'validations.distance.must_be_greater_than', distance: 12
    )]

    assert @endowment.invalid?
    assert_equal 2, @endowment.errors.size
    assert_equal error, @endowment.errors[:back_mileage]
    assert_equal error, @endowment.errors[:in_mileage]

    @endowment.reload

    @endowment.out_mileage = 10
    @endowment.arrive_mileage = 11
    @endowment.back_mileage = 13
    @endowment.in_mileage = 12

    assert @endowment.invalid?
    assert_equal 1, @endowment.errors.size
    assert_equal [I18n.t(
      'validations.distance.must_be_greater_than', distance: 13
    )], @endowment.errors[:in_mileage]
  end

  test "validate update_actions!" do
    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Endowment.count' do
        assert @endowment.update_arrive!
      end
    end

    # Scape the last digit (minute)
    assert_equal I18n.l(Time.now, format: :hour_min)[0..3], @endowment.arrive_at[0..3]

    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Endowment.count' do
        assert @endowment.update_back!
      end
    end

    # Scape the last digit (minute)
    assert_equal I18n.l(Time.now, format: :hour_min)[0..3], @endowment.back_at[0..3]

    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'Endowment.count' do
        assert @endowment.update_in!
      end
    end

    # Scape the last digit (minute)
    assert_equal I18n.l(Time.now, format: :hour_min)[0..3], @endowment.in_at[0..3]
  end
end
