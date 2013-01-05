Fabricator(:intervention) do
  number        { 10000 * rand }
  address       { Faker::Address.street_address }
  near_corner   { Faker::Lorem.sentence }
  kind          { Intervention::KINDS.values.sample }
  kind_notes    { Faker::Lorem.sentence }
  receptor_id   { Fabricate(:user).id }
  hierarchy_id  { 100 }
  observations  { Faker::Lorem.paragraph }
end
