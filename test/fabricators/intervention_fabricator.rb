Fabricator(:intervention) do
  # Gral info
  number                { rand(999) * rand(999) }
  address               { Faker::Address.street_address }
  near_corner           { Faker::Address.street_name }
  kind_notes            { Faker::Lorem.sentence }
  receptor_id           { Fabricate(:user).id }
  observations          { Faker::Lorem.paragraph }
  sco_id                { Fabricate(:sco).id }
  intervention_type_id  { Fabricate(:intervention_type).id }
end
