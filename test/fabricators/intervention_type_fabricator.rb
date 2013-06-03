Fabricator(:intervention_type) do
  name { Faker::Name.name }
  priority { 100 * rand }
  intervention_category_id { 100 * rand }
  image { Faker::Lorem.sentence }
  target { Faker::Lorem.sentence }
  callback { Faker::Lorem.sentence }
end
