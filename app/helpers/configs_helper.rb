module ConfigsHelper

  def configs_subnav
    li = content_tag( :li, link_to( t('menu.firefighters'), configs_firefighters_path ), class: active_nav(firefighters_urls) ) if can?(:read, Sco)
    li += content_tag( :li, link_to( t('menu.scos'), configs_scos_path ), class: active_nav(scos_urls) ) if can?(:read, Sco)
    li += content_tag( :li, link_to( t('menu.hierarchies'), configs_hierarchies_path ), class: active_nav(hierarchies_urls) ) if can?(:read, Hierarchy)
    li += content_tag( :li, link_to( t('menu.trucks'), configs_trucks_path ), class: active_nav(trucks_urls) ) if can?(:read, Sco)
    li += content_tag( :li, link_to(t('view.intervention_types.index_title'), configs_intervention_types_path), class: active_nav( intervention_types_urls ) )
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
    urls += [user_path(@user)] if @user && @user.persisted?
    urls += [new_user_path]
    urls += [edit_user_path(@user)] if @user && @user.persisted?
    urls
  end

  def hierarchies_urls
    urls = [configs_hierarchies_path]
    urls += [configs_hierarchy_path(@hierarchy)] if @hierarchy && @hierarchy.persisted?
    urls += [new_configs_hierarchy_path]
    urls += [edit_configs_hierarchy_path(@hierarchy)] if @hierarchy && @hierarchy.persisted?
    urls
  end

  def scos_urls
    urls = [configs_scos_path]
    urls += [configs_sco_path(@sco)] if @sco && @sco.persisted?
    urls += [new_configs_sco_path]
    urls += [edit_configs_sco_path(@sco)] if @sco && @sco.persisted?
    urls
  end

  def trucks_urls
    urls = [configs_trucks_path]
    urls += [configs_truck_path(@truck)] if @truck && @truck.persisted?
    urls += [new_configs_truck_path]
    urls += [edit_configs_truck_path(@truck)] if @truck && @truck.persisted?
    urls
  end

  def firefighters_urls
    urls = [configs_firefighters_path]
    urls += [configs_firefighter_path(@firefighter)] if @firefighter && @firefighter.persisted?
    urls += [new_configs_firefighter_path]
    urls += [edit_configs_firefighter_path(@firefighter)] if @firefighter && @firefighter.persisted?
    urls
  end
end