class InterventionType < ActiveRecord::Base
  has_paper_trail
  mount_uploader :image, ImageUploader
  mount_uploader :audio, AudioUploader

  COLORS = ['red', 'green', 'blue', 'yellow', 'white']
  COLORS_LIGHTS_OFF = Hash[COLORS.map {|k| [k, false]}]

  scope :without_emergencies, -> () { where(priority: nil) }

  serialize :lights, Hash

  belongs_to :father, class_name: 'InterventionType', foreign_key:
    'intervention_type_id'
  has_many :children, class_name: 'InterventionType'
  has_many :interventions

  before_save :booleanize_lights

  #attr_accessible :name, :priority, :father, :target, :callback, :color,
   # :image, :remote_image_url, :intervention_type_id

  validates :name, :color, presence: true

  scope :only_fathers, -> { where(intervention_type_id: nil) }
  scope :only_children, -> { !only_fathers }
  scope :without_priority, -> { where(priority: nil) }
  scope :with_priority, -> { where.not(priority: nil) }

  def initialize(attributes = nil)
    super(attributes)

    COLORS.each do |light|
      self.lights[light] ||= false
    end
  end

  def self.find_by_lights(lights)
    search_lights = {}
    COLORS.each do |color|
      search_lights[color] = lights[color].to_bool
    end

    all.each do |it|
      if COLORS.map { |c| it.lights[c] == search_lights[c] }.all?
        return it
      end
    end

    nil
  end

  def to_s
    self.parent_name + self.name
  end

  def parent_name
    self.intervention_type_id ? "[#{self.father.to_s}] " : ''
  end

  def has_children?
    children.any?
  end

  def is_root?
    self.intervention_type_id.nil?
  end

  def is_a_son?
    !is_root?
  end

  def self.order_by_children
    collection = []

    only_fathers.each do |it|
      collection << it

      it.children.each do |c|
        collection << c
      end
    end

    collection
  end

  def emergency?
    priority?
  end

  def emergency_or_urgency
    priority? ? 'emergency' : 'urgency'
  end

  private

    def booleanize_lights
      self.lights.keys.each do |light|
        self.lights[light] = self.lights[light].to_bool
      end
    end
end
