module ApplicationHelper
  def title
    [t('app_name'), @title].compact.join(' | ')
  end

  def show_menu_link(options = {})
    name = t("menu.#{options[:name]}")
    classes = []

    classes << 'active' if [*options[:controllers]].include?(controller_name)

    content_tag(
      :li, link_to(name, options[:path]),
      class: (classes.empty? ? nil : classes.join(' '))
    )
  end

  def show_button_dropdown(main_action, extra_actions = [], options = {})
    if extra_actions.blank?
      main_action
    else
      out = ''.html_safe

      out << render(
        partial: 'shared/button_dropdown', locals: {
          main_action: main_action, extra_actions: extra_actions
        }
      )
    end
  end

  def pagination_links(objects, params = nil)
    result = will_paginate objects,
      inner_window: 1, outer_window: 1, params: params,
      renderer: BootstrapPaginationHelper::LinkRenderer,
      class: 'pagination pagination-right'
    page_entries = content_tag(
      :blockquote,
      content_tag(
        :small,
        page_entries_info(objects),
        class: 'page-entries hidden-desktop pull-right'
      )
    )

    unless result
      previous_tag = content_tag(
        :li,
        content_tag(:a, t('will_paginate.previous_label').html_safe),
        class: 'previous_page disabled'
      )
      next_tag = content_tag(
        :li,
        content_tag(:a, t('will_paginate.next_label').html_safe),
        class: 'next disabled'
      )

      result = content_tag(
        :div,
        content_tag(:ul, previous_tag + next_tag),
        class: 'pagination pagination-right'
      )
    end

    content_tag :div, result + page_entries, class: 'pagination-container'
  end

  def link_to_show(*args)
    options = args.extract_options!

    options['class'] ||= 'iconic'
    options['title'] ||= t('label.show')
    options['data-show-tooltip'] ||= true

    link_to_builder '&#xe074;'.html_safe, *args, options
  end

  def link_to_edit(*args)
    options = args.extract_options!

    options['class'] ||= 'iconic'
    options['title'] ||= t('label.edit')
    options['data-show-tooltip'] ||= true

    link_to_builder '&#x270e;'.html_safe, *args, options
  end

  def link_to_destroy(*args)
    options = args.extract_options!

    options['class'] ||= 'iconic'
    options['title'] ||= t('label.delete')
    options['method'] ||= :delete
    options['data-confirm'] ||= t('messages.confirmation')
    options['data-show-tooltip'] ||= true

    link_to_builder '&#xe05a;'.html_safe, *args, options
  end

  def link_to_download(*args)
    options = args.extract_options!

    options['class'] ||= 'iconic'
    options['title'] ||= t('label.download')
    options['data-show-tooltip'] ||= true

    link_to_builder '&#xe044;'.html_safe, *args, options
  end

  def link_to_builder(*args)
    options = args.extract_options!

    if options['remote'] || options[:remote]
      options['data-target'] ||= 'modal'
      options['data-modal'] ||= true
      options['remote'] ||= true
    end

     link_to *args, options
  end

  def errors_for(object, field)
    if object && object.errors[field].any?
      content_tag(:span, object.errors[field].to_sentence, class: 'control-group error')
    end
  end

  def lights_collection_with_translation
    [:red, :blue, :green, :yellow, :white].map do |light|
      [light, t("view.lights.#{light}")]
    end
  end

  def boolean_text_field(value)
    value ? t('label.yes') : t('label.no')
  end

  def ternary_text_field(value)
    case value
      when true  then t('view.buildings.collections.ternary_options.yes')
      when false then t('view.buildings.collections.ternary_options.no')
      else            t('view.buildings.collections.ternary_options.unknown')
    end
  end

  def locale_if_exist(datetime)
    l(datetime) if datetime
  end

  def related_seconds_if_exist(seconds)
    if seconds
      distance_of_time(seconds, accumulate_on: :hours)
    else
      '-'
    end
  end
end
