Fabricator(:firefighter) do
  firstname       { Faker::Name.first_name }
  lastname        { Faker::Name.last_name }
  identification  { 10000 * rand }
end
