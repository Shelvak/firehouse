Fabricator(:relative) do
  relation_type   { Relative::RELATIVE_TYPES.sample }
  name            { Faker::Name.first_name }
  last_name       { Faker::Name.last_name }
  dni             { Faker::Number.number(10) }
  birth_date      { Faker::Date.birthday(18, 99) }
  alive           { [true, false].sample }
  details         { Faker::Lorem.sentence }
  firefighter_id  { Fabricate(:firefighter).id }
end
