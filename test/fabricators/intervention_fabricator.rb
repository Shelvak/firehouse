Fabricator(:intervention) do
  # Gral info
  number          { 10000 * rand }
  address         { Faker::Address.street_address }
  near_corner     { Faker::Lorem.sentence }
  kind            { Intervention::KINDS.values.sample }
  kind_notes      { Faker::Lorem.sentence }
  receptor_id     { Fabricate(:user).id }
  observations    { Faker::Lorem.paragraph }
  sco_id          { Fabricate(:sco).id }

  # Truck info
  truck_id        { Fabricate(:truck).id }
  out_at          { I18n.l(10.hours.ago, format: :hour_min) }
  arrive_at       { I18n.l(10.hours.ago + 10.minutes, format: :hour_min) }
  back_at         { I18n.l(9.hours.ago, format: :hour_min) }
  in_at           { I18n.l(9.hours.ago + 10.minutes, format: :hour_min) }
  out_mileage     { rand(999999) }
  arrive_mileage  { |attr| attr[:out_mileage] + 10 }
  back_mileage    { |attr| attr[:arrive_mileage] + 10 }
  in_mileage      { |attr| attr[:back_mileage] + 10 }
end
