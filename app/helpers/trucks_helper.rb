module TrucksHelper
  def fuel_type_selector(f)
    f.input :fuel_type, collection: Truck::FUEL_TYPE,
      selected: f.objects.fuel_type || Truck::FUEL_TYPE.first
  end

  def truck_type_selector(f)
    f.input :truck_type, collection: Truck::TRUCK_TYPES,
      selected: f.objects.truck_type || Truck::TRUCK_TYPES.first
  end
end
