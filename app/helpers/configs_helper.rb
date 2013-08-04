module ConfigsHelper

  def configs_subnav
    li = content_tag( :li, link_to(t('view.intervention_types.index_title'), configs_intervention_types_path), class: active_nav( intervention_types_urls ) )
    li += content_tag( :li, link_to(t('activerecord.models.user.other'), users_path), class: active_nav( users_urls ) )
    content_tag(:ul, li.html_safe, class: 'nav nav-tabs')
  end

  def intervention_types_subnav
    li = content_tag( :li, link_to(t('view.intervention_types.list_title'), configs_intervention_types_path), class: active_nav( [configs_intervention_types_path] ) )
    li += content_tag( :li, link_to(t('view.intervention_types.priorities'), priorities_configs_intervention_types_path), class: active_nav( [priorities_configs_intervention_types_path] ) )
    content_tag(:ul, li.html_safe, class: 'nav nav-tabs')
  end

  def active_nav(urls)
    if urls.any? { |u| current_page?(u) }
      'active'
    end
  end

  private
  def intervention_types_urls
    [configs_intervention_types_path, priorities_configs_intervention_types_path]
  end

  def users_urls
    urls = [users_path]
    urls += [ user_path(@user) ] if @user
    urls
  end

end