Fabricator(:sco) do
  full_name { Faker::Name.name }
  current   { [true, false].sample }
end
