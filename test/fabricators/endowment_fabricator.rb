Fabricator(:endowment) do
  number            { 100 * rand }
  intervention_id   { Fabricate(:intervention).id }
end
