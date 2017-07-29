module Configs::InterventionTypesHelper
  def lights_priority_link_to(it)
    if it.light_priority?
      [
        it.name,
        content_tag(:span, '&#x2714;'.html_safe, class: 'iconic')
      ].join(' ').html_safe

    else
      link_to(
        it.name,
        lights_priority_configs_intervention_type_path(it.id),
        method: :put
      )
    end
  end

  def clean_lights_link_to(lights)
    link_to(
      'Limpiar',
      clean_light_priorities_configs_intervention_types_path(lights: lights.to_json),
      method: :put
    )
  end

  def iconic
    (0..100).map do |i|
      content_tag(:tr, [
        content_tag(:td, "x27#{i}").html_safe,
        content_tag(:td, content_tag(:span, "&#x27#{i};".html_safe, class: 'iconic').html_safe).html_safe
      ].join().html_safe).html_safe
    end.join.html_safe
  end
end
