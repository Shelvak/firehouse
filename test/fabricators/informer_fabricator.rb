Fabricator(:informer) do
  full_name       { Faker::Name.name }
  nid             { 10000 * rand }
  phone           { Faker::PhoneNumber.phone_number.gsub(/\D/, '') }
  address         { Faker::Address.street_address }
  intervention_id { Fabricate(:intervention).id }
end
