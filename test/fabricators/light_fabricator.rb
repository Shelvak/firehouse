Fabricator(:light) do
  kind { Faker::Lorem.sentence }
  color { Faker::Lorem.sentence }
  intensity { 100 * rand }
end
