class Light < ActiveRecord::Base
  KINDS = [:day, :night, :stay]
  COLORS = [:red, :blue, :green, :white, :yellow]

  has_paper_trail

  validates :kind, :color, :intensity, presence: true

  KINDS.each.each do |kind|
    scope :"on_#{kind}", ->() { where(kind: kind).order(order_by_color) }
  end

  def update_semaphore_brightness
    RedisClient.publish('configs:lights', self.to_json)
  end

  def as_json(options = nil)
    default_options = {
      only: [:kind, :color, :intensity]
    }

    super(default_options.merge(options || {}))
  end

  class << self
    def separed_by_kind
      lights = {}

      KINDS.each do |kind|
        lights[kind] = send("on_#{kind}")
      end

      lights.with_indifferent_access
    end

    def populate
      KINDS.each do |kind|
        COLORS.each do |color|
          where(kind: kind, color: color).first_or_create
        end
      end
    end

    def update_by_kind(opts = {})
      opts = opts.with_indifferent_access
      kind = opts.delete(:kind)

      opts.each do |color, value|
        light = find_or_create_by(color: color, kind: kind)

        if light.intensity.to_i != value.to_i
          light.update_column(:intensity, value.to_i)
          light.update_semaphore_brightness
        end
      end
    end
  end

  def self.order_by_color
    ret = 'CASE'

    COLORS.each_with_index do |color, i|
      ret << " WHEN lights.color = '#{color}' THEN #{i}"
    end

    ret << 'END'
  end
end
