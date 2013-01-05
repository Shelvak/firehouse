Fabricator(:intervention) do
  # Gral info
  number          { 10000 * rand }
  address         { Faker::Address.street_address }
  near_corner     { Faker::Lorem.sentence }
  kind            { Intervention::KINDS.values.sample }
  kind_notes      { Faker::Lorem.sentence }
  receptor_id     { Fabricate(:user).id }
  hierarchy_id    { 100 }
  observations    { Faker::Lorem.paragraph }

  # Truck info
  truck_id        { 1 }
  out_at          { 10.hours.ago }
  arrive_at       { 10.hours.ago + 10.minutes }
  back_at         { 9.hours.ago }
  in_at           { 9.hours.ago + 10.minutes }
  out_mileage     { rand(999999) }
  arrive_mileage  { |attr| attr[:out_mileage] + 10 }
  back_mileage    { |attr| attr[:arrive_mileage] + 10 }
  in_mileage      { |attr| attr[:back_mileage] + 10 }
end
