window.Intervention ||=
  id: ->
    $('fieldset[data-type="intervention"]').data('id')

  persisted: ->
    if Intervention.id() then true else false

  ajaxMethod: ->
    if Intervention.persisted() then 'PUT' else 'POST'

  nameFromForm: (formName)->
    formName.match(/\[(\w+)\]$/)[1]

  bufferToSave: {}

  saveFieldHandler: (e, callback)->
    field = $(e.currentTarget)
    if field.data('skip-save')
      return

    Intervention.saveField(field, callback)

  saveField: (field, callback, hold)->
    fieldName    = field.data('name') || Intervention.nameFromForm(field.attr('name'))
    fieldValue   = field.data('value') || field.val()
    fieldset     = field.parents('fieldset:first')
    fieldsetType = fieldset.data('type')
    fieldsetUrl  = fieldset.data('url')

    hold ||= false

    if hold || (!Intervention.id() && fieldName != 'intervention_type_id')
      Intervention.bufferToSave[fieldsetType] ||= {}
      Intervention.bufferToSave[fieldsetType][fieldName] = fieldValue
      return

    # hash = Intervention.bufferToSave
    # Intervention.bufferToSave = {} # reset buffer
    Intervention.bufferToSave[fieldsetType] ||= {}
    Intervention.bufferToSave[fieldsetType][fieldName] = fieldValue

    $.ajax
      url:  fieldsetUrl
      type: Intervention.ajaxMethod()
      dataType: 'json'
      data: Intervention.bufferToSave
      success: (data)->
        if data.redirectTo
          return window.location.href = data.redirectTo

        if data.errors
          for fieldWithError, msgs of data.errors
            if fieldWithError == 'base' # base no tiene campo especifico
              alert(msgs)
            else
              Intervention.colorizeAndShowFieldErrors(fieldset.find("[name$=\"[#{fieldWithError}]\"]"), msgs)
        else
          for k, v of Intervention.bufferToSave[fieldsetType]
            Intervention.cleanFieldErrors(fieldset.find("[name$=\"[#{k}]\"]"))

          Intervention.bufferToSave = {}

        if callback
          try
            callback()
          catch e
            console.log(e)

      error: Intervention.showErrorWarning

  showErrorWarning: -> alert("Ha habido un error, cuidado")
  colorizeAndShowFieldErrors: (field, msgs)->
    if field && field.length
      # Primero limpiamos y despues volvemos a agregar el error
      Intervention.cleanFieldErrors(field)
      controlGroup = field.parents('.control-group:first')
      controlGroup.addClass('error')
      errors = []
      for message in _.uniq(msgs)
        errors.push("<span class=\"help-inline\" style=\"font-size: 14px;\">#{message}</span>")
      controlGroup.append(errors.join('<br />'))

  cleanFieldErrors: (field)->
    if field && field.length
      controlGroup = field.parents('.control-group:first')
      controlGroup.removeClass('error')
      controlGroup.find('span.help-inline').remove()

  # tokenizeAutocompleteInputs: ->
  #   $('.token-autocomplete:not(.tokenized)').each ->

  #     input = $(this)
  #     input.tokenInput '/interventions/autocomplete_for_firefighter_name.json',
  #       prePopulate: input.data('load'),
  #       theme: 'facebook',
  #       propertyToSearch: 'label',
  #       preventDuplicates: true,
  #       tokenLimit: input.data('token-limit'),
  #       minChars: 3,
  #       hintText: false,
  #       noResultsText: without_result,
  #       searchingText: false
  #       onReady: ->
  #         input.addClass('tokenized')
  #       onAdd: ->
  #         count = input.siblings('.token-input-list-facebook:first')
  #           .find('li.token-input-token-facebook').size()
  #         if (count - input.data('token-limit')) == 0
  #           input.parents('[data-endowment-lines]')
  #             .find('[id^="token-input-intervention"]:visible:first').focus()
  #         input.trigger('change')

  setCurrentTimeToObservations: ->
    input       = $('#intervention_observations')
    wrote       = input.val()
    timeNow     = "[#{Helpers.getHour()}] "

    if _.last(wrote.split("\n")) != timeNow
      if wrote.length
        wrote += "\n#{timeNow}"
      else
        wrote = timeNow

    input.focus().val(wrote)

new Rule
  condition: -> $('#c_interventions').length
  load: ->
    @map.addNewTab ||= (e)->
      e.preventDefault()
      e.stopPropagation()

      link = $(e.currentTarget)
      numbers = []
      $('[data-endowment-link]').each (i, endowmentTab) ->
        numbers.push(Math.abs(endowmentTab.dataset.number))

      nextNumber = _.max(numbers) + 1

      tab = '<li class="active">
        <a class="js-change-tab" data-toggle="tab" data-endowment-link="true" data-number="NUMBER" data-target="#endowments_NUMBER" href="#endowments_NUMBER">NUMBER</a>
      </li>'.replace(/NUMBER/g, nextNumber)

      $.ajax
        url: $(e.currentTarget).data('url')
        type: 'POST'
        dataType: 'json'
        data: { number: nextNumber }
        success: (data) ->
          if data && data.content
            tabContent = $('.tab-content')
            tabContent.find('.active').removeClass('active')
            tabContent.append(data.content)

            $('[data-endowments-items] .nav-tabs').find('.active').removeClass('active')
            $(tab).insertBefore(link)

            Autocomplete.initFirefightersSelect2()

    @map.assignTruckMileage ||= ->
      input = $(this)
      if input.val().length == 0
        out = input.parents('[data-endowment-item]')
          .find('input[name$="[out_mileage]"]')
          .val('')
        Intervention.saveField(out, null, true)
        Intervention.saveField(input)
        return

      $.ajax
        url: '/interventions/autocomplete_for_truck_number'
        dataType: 'json'
        data: { q: input.val() }
        success: (data)->
          parentDiv = input.parents('.intervention_endowments_truck_number:first')
          helpInline = input.parents('td:first').find('.help-inline')
          if data && data[0]
            out = input.parents('[data-endowment-item]:first')
              .find('input[name$="[out_mileage]"]')
              .val(parseInt data[0].mileage)
            truckId = input.parents('[data-endowment-item]:first').find('[name$="[truck_id]"]')
            truckId.val(data[0].id)

            Intervention.saveField(out, null, true)
            Intervention.saveField(truckId)

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
        .find("input[name$='[#{clicked.data('set-time-to')}]']:first")

      inputTarget.val('')
      inputTarget.val(Helpers.getHour()).change()

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

    @map.specialButtonPressed ||= (e) ->
      e.preventDefault()
      e.stopPropagation()

      button = $(this)

      type = button.data('special-button')
      hide = button.data('hide-on-success')

      if button.data('special-sign')
        $.ajax
          url:  "/interventions/#{Intervention.id()}/special_sign"
          type: Intervention.ajaxMethod()
          data: { sign: type}
          success: (data)->
            if data.redirectTo
              return window.location.href = data.redirectTo

            if data.hideElement
              button.hide()

          error: Intervention.showErrorWarning
      else
        Intervention.saveFieldHandler(e, (-> $(hide).hide()))

    @map.ignoreEnter ||= (e) ->
      key = e.which
      if key && (key == 10 || key == 13)
        e.preventDefault()
        e.stopPropagation()

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

    @map.intersectionStreetsSearch ||= ->
      intersections = $('.js-intersection-streets')
      i1 = intersections[0]
      i2 = intersections[1]

      if i1.value.length >= 3 && i2.value.length >= 3
        # Esto engloba el gran mendoza, pero de momento está siendo ignorado
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

      Intervention.saveField($('#intervention_address').val(text), null, true)
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

    @map.checkAjaxBefore ||= (e)->
      if !_.isEmpty(Intervention.bufferToSave)
        e.preventDefault()
        e.stopPropagation()

        Intervention.saveField(
          $('#intervention_observations'),
          -> (window.location.href = e.currentTarget.href)
        )



    Helpers.docOn 'change', '.js-intersection-results', @map.changeMarkerOnResult
    Helpers.docOn 'change', '[data-travel-type]',       @map.alertWhenDistanceIsBig
    Helpers.docOn 'change', '[data-truck-number]',      @map.assignTruckMileage
    Helpers.docOn 'click',  '#add_current_time',        Intervention.setCurrentTimeToObservations
    Helpers.docOn 'click',  '#add_new_endowment',       @map.addNewTab
    Helpers.docOn 'change', 'input,select,textarea',    Intervention.saveFieldHandler
    Helpers.docOn 'click',  '[data-special-button]',    @map.specialButtonPressed
    Helpers.docOn 'click',  '[data-set-time-to]',       @map.setCurrentTimeToTruckData
    Helpers.docOn 'keyup',  '.js-intersection-streets', @map.intersectionStreetsSearch
    Helpers.docOn 'keyup',  'input,select',             @map.ignoreEnter
    Helpers.docOn 'keyup',  'input[name$="[number]"]',  @map.changeEndowmentNumber
    Helpers.docOn 'click',  '[data-check-ajax-before]',  @map.checkAjaxBefore

  unload: ->
    $(document).off 'click', '#add_new_endowment', @map.addNewTab
    $(document).off 'change', '[data-truck-number]', @map.assignTruckMileage
    $(document).off 'click', '[data-set-time-to]', @map.setCurrentTimeToTruckData
    $(document).off 'click', '#add_current_time', Intervention.setCurrentTimeToObservations
    $(document).off 'keyup', 'input[name$="[number]"]', @map.changeEndowmentNumber
    $(document).off 'change', 'input,select,textfield', Intervention.saveFieldHandler
    $(document).off 'click', '[data-special-button]', @map.specialButtonPressed
