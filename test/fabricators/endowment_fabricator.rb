Fabricator(:endowment) do
  number            { 100 * rand }
  endowment_lines_attributes { { 1 => Fabricate.attributes_for(:endowment_line) } }
end
