window.Intervention =
  lastFocusedInput: null

  focusLastFocusedInput: ->
    if Intervention.lastFocusedInput
      $('#' + Intervention.lastFocusedInput.attr('id')).focus()

  saveIntervention: ->
    interventionForm = $('form[data-intervention-form]')
    url              = interventionForm[0].getAttribute('action')
    _method          = interventionForm[0].getAttribute('method')

    if $('#intervention_intervention_type_id').val().toString() != ''
      $.ajax
        url: url
        type: _method
        data: interventionForm.serialize()
        success: (data)->
          $('.content').html(data)

  tokenizeAutocompleteInputs: ->
    $('.token-autocomplete:not(.tokenized)').each ->
      input = $(this)
      input.tokenInput '/interventions/autocomplete_for_firefighter_name.json',
        prePopulate: input.data('load'),
        theme: 'facebook',
        propertyToSearch: 'label',
        preventDuplicates: true,
        tokenLimit: input.data('token-limit'),
        minChars: 3,
        hintText: false,
        noResultsText: without_result,
        searchingText: false
        onReady: ->
          input.addClass('tokenized')
        onAdd: ->
          count = input.siblings('.token-input-list-facebook:first')
            .find('li.token-input-token-facebook').size()
          if (count - input.data('token-limit')) == 0
            input.parents('[data-endowment-lines]')
              .find('[id^="token-input-intervention"]:visible:first').focus()

new Rule
  condition: -> $('#c_interventions').length
  load: ->
    @map.addNewTab ||= (e)->
      e.preventDefault()

      navTabs = $('[data-endowments-items] .nav-tabs')
      navTabs.find('.active').removeClass('active')
      tabContent= $('.tab-content')
      tabContent.find('.active').removeClass('active')

      itemCount = $('[data-endowment-link]:last').data('number') + 1

      dynamicNumber = dynamicForm.match(
        /intervention\[endowments_attributes\]\[(\d+)\]/
      )[1]

      regExp = RegExp(dynamicNumber,"g")

      dynamicTemplate = $(dynamicForm).data().dynamicTemplate

      endowmentForm = dynamicTemplate
        .replace(regExp, itemCount)
        .replace(/dynamicContent/g, itemCount)

      tabContent.append(
        $(endowmentForm).addClass('active').data('number', itemCount)
      )

      $('[data-endowments-items]').append()

      $(dynamicTab.replace(/dynamicContent/g, itemCount))
        .addClass('active')
        .insertBefore('#add_new_endowment')

      $('input[name$="[number]"]:visible:first').val(itemCount)

      Intervention.tokenizeAutocompleteInputs()

    @map.assignTruckMileage ||= ->
      input = $(this)

      $.ajax
        url: '/configs/trucks'
        dataType: 'json'
        data: { q: input.val() }
        success: (data)->
          if data[0]
            input.parents('[data-endowment-item]')
              .find('input[name$="[out_mileage]"]')
              .val(parseInt data[0].mileage)

    @map.setCurrentTimeToTruckData ||= (e) ->
      e.preventDefault()
      e.stopPropagation()
      clicked = $(this)

      inputTarget = clicked.parents('.row-fluid:first')
        .find("input[name$='[#{clicked.data('set-time-to')}]']")

      now = new Date
      inputTarget.val Helpers.getHour()

    @map.setCurrentTimeToObservations ||= ->
      input = $('#intervention_observations')
      writed = input.val()
      writed += "\n" if writed.length

      input.focus()
      input.val(writed + "[#{Helpers.getHour()}]  ")

    @map.changeEndowmentNumber ||= ->
      input = $(this)
      value = input.val()

      input.parents('.tab-pane.active:first').attr('id', "endowments_#{value}")
      input.parents('[data-endowments-items]').find('li.active').html(
        "<a href='#endowments_#{value}' data-toggle='tab' data-number='#{value}'
        data-endowment-link=true> #{value} </a>"
      )


    @map.sendSpecialSign ||= (e) ->
      e.preventDefault()
      e.stopPropagation()

      id = this.getAttribute('data-intervention-id')
      type = this.getAttribute('data-intervention-special-button')

      if id.match(/\d+/)
        $.ajax
          url: '/interventions/' + id + '/special_sign'
          type: 'PUT'
          data: { sign: type }

    @map.handleEnterOnInputs ||= (e) ->
      key = e.which

      if key == 13 && !e.ctrlKey
        e.preventDefault()
        Intervention.saveIntervention()

      if (key == 10 || key == 13) && e.ctrlKey
        $('form').submit()


    $(document).on 'click', '#add_new_endowment', @map.addNewTab
    $(document).on 'change', '[data-truck-number]', @map.assignTruckMileage
    $(document).on 'click', '[data-set-time-to]', @map.setCurrentTimeToTruckData
    $(document).on 'click', '#add_current_time', @map.setCurrentTimeToObservations
    $(document).on 'keyup', 'input[name$="[number]"]', @map.changeEndowmentNumber
    $(document).on 'click', '[data-intervention-saver="important-button"]', Intervention.saveIntervention
    $(document).on 'change', '[data-intervention-saver]', Intervention.saveIntervention

    # Fucking fix for double trigger....
    $(document).off('click', '[data-intervention-special-button]').on('click', '[data-intervention-special-button]', @map.sendSpecialSign)
    $(document).off('keypress').on('keypress', @map.handleEnterOnInputs)

  unload: ->
    $(document).off 'click', '#add_new_endowment', @map.addNewTab
    $(document).off 'change', '[data-truck-number]', @map.assignTruckMileage
    $(document).off 'click', '[data-set-time-to]', @map.setCurrentTimeToTruckData
    $(document).off 'click', '#add_current_time', @map.setCurrentTimeToObservations
    $(document).off 'keyup', 'input[name$="[number]"]', @map.changeEndowmentNumber
    $(document).off 'click', '[data-intervention-saver="important-button"]', Intervention.saveIntervention
    $(document).off 'change', '[data-intervention-saver]', Intervention.saveIntervention
    $(document).off 'click', '[data-intervention-special-button]', @map.sendSpecialSign
    $(document).off 'keyup', 'input', @map.handleEnterOnInputs

jQuery ($) ->
  $(document).on 'focusin', 'input', ->
    Intervention.lastFocusedInput = $(this)
