Fabricator(:truck) do
  number  { rand(999) * rand(999) }
  mileage { 100 * rand }
end
