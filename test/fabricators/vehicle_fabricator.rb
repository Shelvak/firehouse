Fabricator(:vehicle) do
  mark { Faker::Lorem.sentence }
  model { Faker::Lorem.sentence }
  year { Faker::Lorem.sentence }
  domain { Faker::Lorem.sentence }
  mobile_intervention_id { 100 * rand }
end
