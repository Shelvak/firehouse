window.Intervention ||=
  showErrorWarning: -> alert("Ha habido un error, cuidado")

  lastFocusedTab: null
  lastFocusedInput: null

  focusLastTab: ->
    if Intervention.lastFocusedTab
      $("[href=\"#{Intervention.lastFocusedTab}\"]").click()

  focusLastFocusedInput: ->
    if Intervention.lastFocusedInput
      $('#' + Intervention.lastFocusedInput.attr('id')).focus()

  saveIntervention: (e, updatedPoint, no_refresh) ->
    interventionForm = $('form[data-intervention-form]')
    url              = interventionForm[0].getAttribute('action')
    _method          = interventionForm[0].getAttribute('method')
    selector         = $('#intervention_intervention_type_id')

    $('.js-no-refresh-param').val(!!no_refresh)

    # Important button click
    interventionSaver = if this.attributes
      this.attributes['data-intervention-saver']

    if interventionSaver &&
        interventionSaver.value.toString() == 'important-button' &&
        this.attributes.target &&
        this.attributes.target.value

      selector.val(this.attributes.target.value)

    if selector.val().toString() != ''
      $.ajax
        url: url
        type: _method
        data: interventionForm.serialize()
        success: (data)->
          criticError = (typeof(data) == 'object' && data.error)
          if $.trim(data) && !no_refresh && !criticError
            $('.content').html(data)
            Intervention.focusLastTab()
            if $('.error').length
              $('.error:first')[0].scrollIntoView(true)

          if updatedPoint
            InterventionUpdater.emitEvent('new intervention')
          if criticError
            Intervention.showErrorWarning()
        error: Intervention.showErrorWarning

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

      numbers = []
      $('[data-endowment-link]').each (i, e) -> numbers.push(Math.abs(e.dataset.number))
      itemCount = _.max(numbers) + 1


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
      Intervention.lastFocusedTab = "#endowments_#{itemCount}"

    @map.assignTruckMileage ||= ->
      input = $(this)
      if input.val().length == 0
        input.parents('[data-endowment-item]')
          .find('input[name$="[out_mileage]"]')
          .val('')
        return

      $.ajax
        url: '/interventions/autocomplete_for_truck_number'
        dataType: 'json'
        data: { q: input.val() }
        success: (data)->
          parentDiv = input.parents('.intervention_endowments_truck_number:first')
          helpInline = input.parents('td:first').find('.help-inline')
          if data && data[0]
            input.parents('[data-endowment-item]')
              .find('input[name$="[out_mileage]"]')
              .val(parseInt data[0].mileage)
            input.parents('[data-endowment-item]').find('[name$="[truck_id]"]').val(data[0].id)
            parentDiv.removeClass('error')
            helpInline.hide()
          else
            parentDiv.addClass('error')
            helpInline.show()

    @map.setCurrentTimeToTruckData ||= (e) ->
      e.preventDefault()
      e.stopPropagation()
      clicked = $(this)

      inputTarget = clicked.parents('.row-fluid:first')
        .find("input[name$='[#{clicked.data('set-time-to')}]']")

      inputTarget.val Helpers.getHour()
      Intervention.saveIntervention()

    @map.setCurrentTimeToObservations ||= ->
      input = $('#intervention_observations')
      writed = input.val()
      writed += "\n" if writed.length

      input.focus()
      input.val(writed + "[#{Helpers.getHour()}]  ")

    @map.changeEndowmentNumber ||= ->
      input = $(this)
      value = input.val()

      if value < 0
        value = Math.abs(value)
        input.val(value)

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
      refresh = this.getAttribute('data-refresh-page')

      Intervention.saveIntervention(null, null, true)

      if id.match(/\d+/)
        $.ajax
          url: '/interventions/' + id + '/special_sign'
          type: 'PUT'
          data: { sign: type, refresh: refresh}
          success: (data)->
            if +(data) == 302
              window.location.href = '/interventions/' + id
              return
            if $.trim(data)
              $('.content').html(data)
              Intervention.focusLastTab()

    @map.handleEnterOnInputs ||= (e) ->
      key = e.which

      if e.target && e.target.type == 'textarea'
        return

      if (key == 10 || key == 13)
        if e.ctrlKey
          $('form').submit()
        else
          e.preventDefault()
          e.stopPropagation()
          if e.target && !e.target.getAttribute('data-ignore-enter')
            Intervention.saveIntervention()

    @map.ignoreEnter ||= (e) ->
      e.preventDefault()
      e.stopPropagation()

    @map.enterTriggerChange ||= (e) ->
      e.preventDefault()
      e.stopPropagation()

      key = e.which
      if (key == 10 || key == 13)
        $(e.currentTarget).trigger('change')


    @map.alertWhenDistanceIsBig ||= (e) ->
      $input = $(e.target)
      group_parent = $input.parents('.control-group:first')[0]
      travel_type_changed = e.target.getAttribute('data-travel-type')
      travel_type_changed_value = $input.val()
      max_distance_warning = 50
      alert_text = "Más de #{max_distance_warning}km recorridos"

      switch travel_type_changed
        when 'in_mileage'
          back_mileage = $input.parents('fieldset:first').find('[data-travel-type="back_mileage"]')
          back_mileage_value = back_mileage.val()

          if (travel_type_changed_value - back_mileage_value) > max_distance_warning
            window.alert(alert_text)
            group_parent.classList.add('error')
          else
            group_parent.classList.remove('error')

        when 'back_mileage'
          arrive_mileage = $input.parents('fieldset:first').find('[data-travel-type="arrive_mileage"]')
          arrive_mileage_value = arrive_mileage.val()

          if (travel_type_changed_value - arrive_mileage_value) > max_distance_warning
            window.alert(alert_text)
            group_parent.classList.add('error')
          else
            group_parent.classList.remove('error')


        when 'arrive_mileage'
          out_mileage = $input.parents('fieldset:first').find('[data-travel-type="out_mileage"]')
          out_mileage_value = out_mileage.val()

          if (travel_type_changed_value - out_mileage_value) > max_distance_warning
            window.alert(alert_text)
            group_parent.classList.add('error')
          else
            group_parent.classList.remove('error')

    @map.saveLastActiveTab ||= (e) ->
      data = e.currentTarget.dataset
      if data && data.target
        Intervention.lastFocusedTab = data.target

    @map.intersectionStreetsSearch ||= ->
      intersections = $('.js-intersection-streets')
      i1 = intersections[0]
      i2 = intersections[1]

      if i1.value.length >= 3 && i2.value.length >= 3
        bounds = new google.maps.LatLngBounds()
        bounds.extend(new google.maps.LatLng(-33.103957, -68.687023))
        bounds.extend(new google.maps.LatLng(-32.785942, -68.961668))

        params = {
          new_forward_geocoder: true
          key: "AIzaSyCAOAVprqJGiyLRMIGpyQqo_7VWKycNqJA" # mover esto a secret
          address: i1.value + ' y ' + i2.value + ', godoy cruz, mendoza, argentina'
        }

        $.ajax
          url: "https://maps.googleapis.com/maps/api/geocode/json"
          datatype: 'json'
          data: params
          success: (data)->
            if data.status
              select = document.querySelector('.js-intersection-results')

              $(select).find('option').remove()

              # Prompt
              # option = document.createElement('option')
              # option.text = ''
              # select.add(option)

              for result in data.results
                option = document.createElement('option')
                option.text     = result.formatted_address

                option.dataset.lng = result.geometry.location.lng
                option.dataset.lat = result.geometry.location.lat

                select.add(option)
              $(select).show()

    @map.changeMarkerOnResult ||= (e)->
      select = $(e.currentTarget)
      option = select.find('option:selected')
      text   = option.val()
      if text.length <= 0
        return

      $('#intervention_address').val(text)
      event = {
        getPlace: ->
          {
            geometry: {
              location: {
                lat: -> option.data('lat')
                lng: -> option.data('lng')
              }
            }
          }
      }
      Leaflet.changeMarker(text, event)


    $(document).on 'keyup', '.js-intersection-streets', @map.intersectionStreetsSearch
    $(document).on 'change', '.js-intersection-results', @map.changeMarkerOnResult
    $(document).on 'click', '#add_new_endowment', @map.addNewTab
    $(document).on 'change', '[data-truck-number]', @map.assignTruckMileage
    $(document).on 'click', '[data-set-time-to]', @map.setCurrentTimeToTruckData
    $(document).on 'click', '#add_current_time', @map.setCurrentTimeToObservations
    $(document).on 'keyup', 'input[name$="[number]"]', @map.changeEndowmentNumber
    $(document).on 'keyup', '[data-ignore-enter]', @map.ignoreEnter
    $(document).on 'keyup', '[data-enter-trigger-change]', @map.enterTriggerChange

    # Fucking fix for double trigger....
    $(document).off('click', '[data-intervention-special-button]').on('click', '[data-intervention-special-button]', @map.sendSpecialSign)
    $(document).off('change', '[data-travel-type]').on 'change', '[data-travel-type]', @map.alertWhenDistanceIsBig
    $(document).off('keypress').on('keypress', '[data-intervention-form="true"]', @map.handleEnterOnInputs)
    $(document).off('click', '[data-intervention-saver="important-button"]').on 'click', '[data-intervention-saver="important-button"]', Intervention.saveIntervention
    $(document).off('change', '[data-intervention-saver]').on 'change', '[data-intervention-saver]', Intervention.saveIntervention
    $(document).on 'click', '.js-change-tab', @map.saveLastActiveTab

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
