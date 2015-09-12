class Configs::LightsController < ApplicationController
  before_filter :authenticate_user!

  def brightness
    @title = t('view.intervention_types.index_title')

    Light.update_by_kind(lights_params) if request_is_for_update?

    @lights = Light.separed_by_kind
    @volume = $redis.get('volume') || 30

    if request.format.js?
      render partial: 'light_kind',
        locals: { kind: params[:kind], lights: @lights },
        content_type: 'text/html'
    end
  end

  def volume
    volume = params[:volume_changer][:volume].to_i

    #TODO: Send to redis_module
    $redis.set('volume', volume)
    $redis.publish('volume-config', volume)

    render partial: 'volume', locals: { volume: volume },
      content_type: 'text/html'
  end

    private

      def request_is_for_update?
        ['put', 'patch', 'post'].include?(request.method.downcase)
      end

      def lights_params
        kind = params[:kind]

        params.require(:"#{kind}_lights").permit(*Light::COLORS)
                                         .merge(kind: kind)
      end
end
