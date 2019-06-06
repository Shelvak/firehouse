window.Autocomplete =
  initFirefightersSelect2: ->
    if _.isEmpty(Autocomplete.firefighterData)
      $.ajax
        url: '/interventions/autocomplete_for_firefighter_name.json',
        dataType: 'json',
        cache: true
        success: (data) ->
          Autocomplete.firefighterData = data
          Autocomplete.initFirefightersSelect2()
    else
      $('select.multi-autocomplete-field:not([data-observed]):visible').each (i, element) ->
        Autocomplete.firefightersSelect2($(element))

  firefightersSelect2: (element) ->
    opts = {
      selectOnClose: false,
      closeOnSelect: false,
      allowClear:    true
      multiple:      true,
      data:          Autocomplete.firefighterData,
      language:      'es',
      placeholder:   ''
    }

    if element.data('multi-select')
      opts.maximumSelectionLength = 0
      opts.closeOnSelect          = false
      opts.multiple               = true
    else
      opts.maximumSelectionLength = 1
      opts.closeOnSelect = true

    element.select2(opts)
    element.val(element.data('selected-ids')).trigger('change')
    element.attr('data-observed', true)

jQuery ($)->
  $(document).on 'change', 'input.autocomplete-field', ->
    if /^\s*$/.test($(this).val())
      $(this).next('input.autocomplete-id:first').val('')

  $(document).on 'focus', 'input.autocomplete-field:not([data-observed])', ->
    input = $(this)

    input.autocomplete
      source: (request, response)->
        $.ajax
          url: input.data('autocompleteUrl')
          dataType: 'json'
          data: { q: request.term }
          success: (data)->
            response $.map data, (item)->
              content = $('<div></div>')

              content.append $('<span class="title"></span>').text(item.label)

              if item.informal
                content.append $('<small></small>').text(item.informal)

              { label: content.html(), value: item.label, item: item }
      type: 'get'
      select: (event, ui)->
        selected = ui.item

        input.val(selected.value)
        input.data('item', selected.item)
        $(input.data('autocompleteIdTarget')).val(selected.item.id)

        if !input.data('autocompleteIdTarget') && input.data('autocompleteClassTarget')
          input.parents('.row-fluid:first')
            .find(input.data('autocompleteClassTarget'))
              .val(selected.item.id)


        input.trigger 'autocomplete:update', input

        false
      open: -> $('.ui-menu').css('width', input.width())

    input.data('ui-autocomplete')._renderItem = (ul, item)->
      $('<li></li>').data('item.autocomplete', item).append(
        $('<a></a>').html(item.label)
      ).appendTo(ul)
  .attr('data-observed', true)

  $(document).on 'shown.bs.tab', ->
    Autocomplete.initFirefightersSelect2()

  Autocomplete.initFirefightersSelect2()
