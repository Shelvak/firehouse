module ConfigsHelper

  def configs_subnav

  end

  def intervention_types_subnav
    li = content_tag( :li, link_to(t('view.intervention_types.index_title'), configs_intervention_types_path), class: active_nav( [configs_intervention_types_path] ) )
    li += content_tag( :li, link_to(t('view.intervention_types.priorities'), priorities_configs_intervention_types_path), class: active_nav( [priorities_configs_intervention_types_path] ) )
    content_tag(:ul, li.html_safe, class: 'nav nav-tabs')
  end

  def active_nav(urls)
    if urls.any? { |u| current_page?(u) }
      'active'
    end
  end

end