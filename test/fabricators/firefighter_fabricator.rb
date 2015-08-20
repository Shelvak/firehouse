Fabricator(:firefighter) do
  firstname       { Faker::Name.first_name }
  lastname        { Faker::Name.last_name }
  identification  { Faker::Number.number(10) }
  user_id         { Fabricate(:user).id }
end
