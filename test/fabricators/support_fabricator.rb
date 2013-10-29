Fabricator(:support) do
  support_type            { Faker::Lorem.sentence }
  number                  { Faker::Lorem.sentence }
  responsible             { Faker::Lorem.sentence }
  driver                  { Faker::Lorem.sentence }
  owner                   { Faker::Lorem.sentence }
  mobile_intervention_id  { Fabricate(:mobile_intervention).id }
end
