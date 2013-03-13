Fabricator(:endowment_line) do
  firefighter_id  { Fabricate(:firefighter).id }
  charge          { EndowmentLine::CHARGES.keys.sample }
end
