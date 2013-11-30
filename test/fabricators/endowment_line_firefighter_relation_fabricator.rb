Fabricator(:endowment_line_firefighter_relation) do
  firefighter_id      { Fabricate(:firefighter).id }
  endowment_line_id   { Fabricate(:endowment_line).id }
end
