Fabricator(:mobile_intervention) do
  date { rand(1.year).ago }
  emergency { Faker::Lorem.sentence }
  observations { Faker::Lorem.paragraph }
  intervention_id { 100 * rand }
end
