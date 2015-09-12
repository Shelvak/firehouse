module TrucksHelper
  def fuel_type_selector(f)
    f.input :fuel_type, collection: Truck::FUEL_TYPE, selected: Truck::FUEL_TYPE[0]
  end

  def truck_type_selector(f)
    f.input :truck_type, collection: Truck::TRUCK_TYPES, selected: Truck::TRUCK_TYPES[0]
  end
end
