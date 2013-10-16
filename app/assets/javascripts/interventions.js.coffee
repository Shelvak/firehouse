window.Intervention =
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
        onAdd: ->
          console.log('rock')
          console.log $(this)
          count = input.siblings('.token-input-list-facebook:first')
            .find('li.token-input-token-facebook').size()
          console.log(count)
          if (count - input.data('token-limit')) == 0
            input.parents('[data-endowment-lines]')
              .find('[id^="token-input-intervention"]:visible:first').focus()

new Rule
  condition: -> $('#c_interventions').length
  load: ->
    @map.addNewTab ||= (e)->
      e.preventDefault()

      $('.token-autocomplete:not(.tokenized)').each ->
        $(this).addClass('tokenized')

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
        url: '/trucks'
        dataType: 'json'
        data: { q: input.val() }
        success: (data)->
          if data[0]
            input.parents('[data-endowment-item]')
              .find('input[name$="[out_mileage]"]')
              .val(parseInt data[0].mileage)

    @map.setCurrentTimeToTruckData ||= ->
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

    $(document).on 'click', '#add_new_endowment', @map.addNewTab
    $(document).on 'change', '[data-truck-number]', @map.assignTruckMileage
    $(document).on 'click', '[data-set-time-to]', @map.setCurrentTimeToTruckData
    $(document).on 'click', '#add_current_time', @map.setCurrentTimeToObservations
    $(document).on 'keyup', 'input[name$="[number]"]', @map.changeEndowmentNumber

  unload: ->
    $(document).off 'click', '#add_new_endowment', @map.addNewTab
    $(document).off 'change', '[data-truck-number]', @map.assignTruckMileage
    $(document).off 'click', '[data-set-time-to]', @map.setCurrentTimeToTruckData
    $(document).off 'click', '#add_current_time', @map.setCurrentTimeToObservations
    $(document).off 'keyup', 'input[name$="[number]"]', @map.changeEndowmentNumber

jQuery ($) ->
  # Doble iniciador por turbolinks
  Intervention.tokenizeAutocompleteInputs()

  $(document).on 'page:change', ->
    Intervention.tokenizeAutocompleteInputs()



