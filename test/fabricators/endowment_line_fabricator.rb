Fabricator(:endowment_line) do
  charge          { EndowmentLine::CHARGES.keys.sample }
end
