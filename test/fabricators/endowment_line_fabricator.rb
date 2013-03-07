Fabricator(:endowment_line) do
  firefighter_id  { Fabricate(:firefighter).id }
  charge          { Faker::Lorem.word }
  endowment_id    { Fabricate(:endowment).id }
end
