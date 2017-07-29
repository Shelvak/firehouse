module Configs::LightsHelper
  def lights_subnav
    li = Light::KINDS.map do |kind|
      _path = configs_lights_brightness_path(kind: kind)

      content_tag(
        :li, link_to(t("view.lights.#{kind}"), _path), class: active_nav([_path])
      )
    end.join.html_safe

    content_tag(:ul, li, class: 'nav nav-tabs')
  end

  def light_range_input(form, light, kind)
    lights_kind = "#{kind}_lights"
    color       = light.color
    id          = "#{lights_kind}_#{color}"

    html =  form.label color, t("view.lights.#{color}")
    html += form.range_field :intensity, min: 0, max: 100,
      name: "#{lights_kind}[#{color}]",
      id: id, value: light.intensity,
      data: { range_value_changer: true }

    value = content_tag(:span, light.intensity, data: { range_value_of: id })

    html += content_tag(:span, value.html_safe + '%', class: 'badge badge-info')
    html.html_safe
  end

  def show_lights_with_values(lights)
    colors = lights.map do |k, v|
      t('view.lights.' + k) if v
    end.compact.join(' | ')
  end
end
