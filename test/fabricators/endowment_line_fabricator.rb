Fabricator(:endowment_line) do
  charge              { EndowmentLine::CHARGES.keys.sample }
  firefighters_names  { Fabricate(:firefighter).id.to_s }
end
