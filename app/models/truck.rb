class Truck < ActiveRecord::Base
  has_paper_trail
  has_magick_columns number: :integer

  BRANDS = ['Alfa Romeo', 'America Lafrance', 'Arctic Cat', 'Autocar', 'Batacazo',
            'Bedfor, BMW', 'Can-Am', 'Canestrari', 'Chevrolet', 'Chrysler',
            'Citroen', 'Daf', 'Denis, Deutz', 'Dimex', 'Dodge', 'DYNAMIC',
            'Emergency ONE (e-ONE)', 'Federal Motor, Fiat', 'Ford', 'Gaz', 'GMC',
            'Hahn', 'HME-LUVERNE', 'Honda', 'Hyundai', 'International, Isuzu',
            'Iveco', 'Jeep', 'Kawasaki', 'Kia', 'KIDDE', 'KTM', 'Land Rover',
            'Mack', 'Magirus Deuz', 'Man', 'Mazda', 'Mercedes Benz', 'Mit',
            'Mitsubishi', 'Motomel', 'Nissan', 'Otra', 'Peugeot', 'Pierce',
            'Polaris', 'Renault', 'Scania', 'Simon Duplex', 'Spartan', 'Suzuki',
            'Toyota', 'Unimog', 'Volkswagen', 'Volvo', 'Yamaha', 'Zanella', 'Zil']

  TRUCK_TYPES = [
      I18n.t('view.interventions.truck.types.ambulance'),
      I18n.t('view.interventions.truck.types.boats'),
      I18n.t('view.interventions.truck.types.cistern'),
      I18n.t('view.interventions.truck.types.dangerous'),
      I18n.t('view.interventions.truck.types.fast_attack'),
      I18n.t('view.interventions.truck.types.heavy'),
      I18n.t('view.interventions.truck.types.hidro_stair'),
      I18n.t('view.interventions.truck.types.light'),
      I18n.t('view.interventions.truck.types.medium'),
      I18n.t('view.interventions.truck.types.other'),
      I18n.t('view.interventions.truck.types.rescue'),
      I18n.t('view.interventions.truck.types.transport')
  ]

  FUEL_TYPE = [
      I18n.t('view.interventions.truck.fuel_type.gas'),
      I18n.t('view.interventions.truck.fuel_type.gasoil'),
      I18n.t('view.interventions.truck.fuel_type.hybrid'),
      I18n.t('view.interventions.truck.fuel_type.naphtha')
  ]

  validates :number, presence: true
  validates :number, uniqueness: true

  has_many :endowments

  def to_s
    self.number
  end

  alias_method :label, :to_s

  def as_json(options = nil)
    default_options = {
      only: [:id],
      methods: [:label, :mileage]
    }

    super(default_options.merge(options || {}))
  end

  def self.filtered_list(query)
    query.present? ? magick_search(query) : all
  end
end
