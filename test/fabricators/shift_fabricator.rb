Fabricator(:shift) do
  firefighter { references }
  start_at { rand(1.year).ago }
  finish_at { rand(1.year).ago }
  kind { 100 * rand }
  notes { Faker::Lorem.sentence }
end
