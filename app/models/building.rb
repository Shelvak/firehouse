class Building < ActiveRecord::Base
  has_paper_trail

  belongs_to :mobile_intervention
  has_many :people

  #attr_accessible :address, :description, :floor, :roof, :window, :electrics,
  #  :damage, :mobile_intervention_id

  validates :address, presence: true

  AFFECTED_AREAS_FOR_COLLECTION = [
      I18n.t('view.buildings.collections.affected_areas.no_evactuation'),
      I18n.t('view.buildings.collections.affected_areas.kilometers'),
      I18n.t('view.buildings.collections.affected_areas.hectare'),
      I18n.t('view.buildings.collections.affected_areas.meters'),
      I18n.t('view.buildings.collections.affected_areas.partial_evacuation'),
      I18n.t('view.buildings.collections.affected_areas.total_evactuation'),
      I18n.t('view.buildings.collections.affected_areas.other')
  ]
  BUILDING_TYPES_FOR_COLLECTION = [
      I18n.t('view.buildings.collections.building_types.house'),
      I18n.t('view.buildings.collections.building_types.apartment'),
      I18n.t('view.buildings.collections.building_types.booth'),
      I18n.t('view.buildings.collections.building_types.ranch'),
      I18n.t('view.buildings.collections.building_types.multi'),
      I18n.t('view.buildings.collections.building_types.other')
  ]
  ROOF_TYPES_FOR_COLLECTION = [
      I18n.t('view.buildings.collections.building_types.wooden'),
      I18n.t('view.buildings.collections.building_types.gypsum'),
      I18n.t('view.buildings.collections.building_types.tile'),
      I18n.t('view.buildings.collections.building_types.cardbodard'),
      I18n.t('view.buildings.collections.building_types.other')
  ]
  WINDOW_TYPES_FOR_COLLECTION = [
      I18n.t('view.buildings.collections.window_types.wooden'),
      I18n.t('view.buildings.collections.window_types.iron'),
      I18n.t('view.buildings.collections.window_types.aluminium'),
      I18n.t('view.buildings.collections.window_types.plastic'),
      I18n.t('view.buildings.collections.window_types.wooden'),
  ]
  TERNARY_OPTIONS_FOR_COLLECTION = [
      [I18n.t('view.buildings.collections.ternary_options.yes'), true],
      [I18n.t('view.buildings.collections.ternary_options.no'), false],
      [I18n.t('view.buildings.collections.ternary_options.unknown'), nil]
  ]
end
