Fabricator(:truck) do
  number { 100 * rand }
  mileage { 100 * rand }
end
