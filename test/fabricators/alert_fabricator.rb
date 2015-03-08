Fabricator(:alert) do
  intervention_id { Fabricate(:intervention).id }
end
