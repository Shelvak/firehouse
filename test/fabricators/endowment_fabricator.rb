Fabricator(:endowment) do
  number            { rand(999) * rand(999) }
  endowment_lines_attributes { { 1 => Fabricate.attributes_for(:endowment_line) } }

  # Truck info
  truck_id        { Fabricate(:truck).id }
  out_at          { I18n.l(10.minutes.ago, format: :hour_min) }
  arrive_at       { I18n.l(10.minutes.ago + 1.minutes, format: :hour_min) }
  back_at         { I18n.l(8.minutes.ago, format: :hour_min) }
  in_at           { I18n.l(8.minutes.ago + 1.minutes, format: :hour_min) }
  out_mileage     { rand(999999) }
  arrive_mileage  { |attr| attr[:out_mileage] + 10 }
  back_mileage    { |attr| attr[:arrive_mileage] + 10 }
  in_mileage      { |attr| attr[:back_mileage] + 10 }
end
