Fabricator(:shift) do
  firefighter_id { Fabricate(:firefighter).id }
  start_at       { rand(100).days.ago }
  finish_at      { |attr| attr[:start_at] + rand(1..9).hours }
  kind           { Shift::KINDS.keys.sample }
  notes          { Faker::Lorem.sentence }
end
