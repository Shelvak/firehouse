class Light < ActiveRecord::Base
  KINDS = [:day, :night, :stay]
  COLORS = [:red, :blue, :green, :white, :yellow]

  has_paper_trail

  validates :kind, :color, :intensity, presence: true

  KINDS.each.each do |kind|
    scope :"on_#{kind}", ->() { where(kind: kind) }
  end

  def update_semaphore_brightness
    $redis.publish('configs:lights', self.to_json)
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
          create(kind: kind, color: color)
        end
      end
    end

    def update_by_kind(opts = {})
      opts = opts.with_indifferent_access
      kind = opts.delete(:kind)

      opts.each do |color, value|
        light = find_by(color: color, kind: kind)
        light.update_column(:intensity, value.to_i)
        light.update_semaphore_brightness
      end
    end
  end
end
