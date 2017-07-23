Fabricator(:docket) do
  firefighter_id { 100 * rand }
  file { Faker::Lorem.sentence }
  title { Faker::Lorem.sentence }
  description { Faker::Lorem.paragraph }
end
