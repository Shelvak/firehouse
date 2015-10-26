Fabricator(:person) do
  name                { Faker::Name.name }
  last_name           { Faker::Name.name }
  address             { Faker::Lorem.sentence }
  dni_type            { Faker::Lorem.sentence }
  dni_number          { Faker::Lorem.sentence }
  age                 { 100 * rand }
  phone_number        { Faker::Lorem.sentence }
  relation            { Faker::Lorem.sentence }
  genre               { Person::GENERES_FOR_COLLECTION.sample }
  moved_to            { Faker::Lorem.sentence }
  injuries            { Faker::Lorem.sentence }
  building_id         { Fabricate(:building).id }
  vehicle_id          { Fabricate(:vehicle).id }
end
