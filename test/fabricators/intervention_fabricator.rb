Fabricator(:intervention) do
  # Gral info
  address               { Faker::Address.street_address }
  near_corner           { Faker::Address.street_name }
  kind_notes            { Faker::Lorem.sentence }
  receptor_id           { Fabricate(:user).id }
  observations          { Faker::Lorem.paragraph }
  sco
  intervention_type
end
