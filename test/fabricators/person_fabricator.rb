Fabricator(:person) do
  name { Faker::Name.name }
  last_name { Faker::Name.name }
  address { Faker::Lorem.sentence }
  dni_type { Faker::Lorem.sentence }
  dni_number { Faker::Lorem.sentence }
  age { 100 * rand }
  phone_number { Faker::Lorem.sentence }
  relation { Faker::Lorem.sentence }
  moved_to { Faker::Lorem.sentence }
  injuries { Faker::Lorem.sentence }
end
