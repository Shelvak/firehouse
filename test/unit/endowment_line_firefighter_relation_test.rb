require 'test_helper'

class EndowmentLineFirefighterRelationTest < ActiveSupport::TestCase

  setup do
    intervention = Fabricate(:intervention)
    @endowment_line = intervention.endowments.sample.endowment_lines.sample
  end

  test 'create' do
    assert_difference 'EndowmentLineFirefighterRelation.count' do
      assert_difference 'PaperTrail::Version.count', 3 do
        assert EndowmentLineFirefighterRelation.create(
          endowment_line_id: @endowment_line.id,
          firefighter_id: Fabricate(:firefighter).id
        )
      end
    end
  end

  test 'destroy' do
    @relation = Fabricate(
      :endowment_line_firefighter_relation,
      endowment_line_id: @endowment_line.id,
      firefighter_id: Fabricate(:firefighter).id
    )

    assert_difference 'PaperTrail::Version.count' do
      assert_difference 'EndowmentLineFirefighterRelation.count', -1 do
        assert @relation.destroy
      end
    end
  end
end
