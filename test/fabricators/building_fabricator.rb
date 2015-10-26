Fabricator(:building) do
  address                 { Faker::Lorem.sentence }
  affected_surface        { Building::AFFECTED_AREAS_FOR_COLLECTION.sample }
  automatic_alert         { [true, false, nil].sample }
  building_type           { Building::BUILDING_TYPES_FOR_COLLECTION.sample }
  description             { Faker::Lorem.paragraph }
  details                 { Faker::Lorem.paragraph }
  extinguishers           { [true, false, nil].sample }
  fire_hydrants           { [true, false, nil].sample }
  floor                   { Faker::Number.number(2) }
  number_of_floors        { Faker::Number.number(2) }
  number_of_rooms         { Faker::Number.number(3) }
  roof_type               { Building::ROOF_TYPES_FOR_COLLECTION.sample }
  window_type             { Building::WINDOW_TYPES_FOR_COLLECTION.sample }
  mobile_intervention_id  { Fabricate(:mobile_intervention).id }
end
