module TrucksHelper
  def fuel_type_selector(f)
    f.input :fuel_type, collection: Truck::FUEL_TYPE,
      selected: f.object.fuel_type || Truck::FUEL_TYPE.first
  end

  def truck_type_selector(f)
    f.input :truck_type, collection: Truck::TRUCK_TYPES,
      selected: f.object.truck_type || Truck::TRUCK_TYPES.first
  end
end
