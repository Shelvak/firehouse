Fabricator(:mobile_intervention) do
  date              { rand(1..300).days.ago }
  emergency         { Faker::Lorem.sentence }
  observations      { Faker::Lorem.paragraph }
  endowment_id      { Fabricate(:endowment).id }
end
