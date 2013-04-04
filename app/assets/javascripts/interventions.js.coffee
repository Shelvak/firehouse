new Rule
  condition: -> $('#c_interventions').length
  load: ->
    @map.addNewTab ||= (e)->
      e.preventDefault()

      navTabs = $('[data-endowments-items] .nav-tabs')
      navTabs.find('.active').removeClass('active')
      tabContent= $('.tab-content')
      tabContent.find('.active').removeClass('active')
                                                                                    
      itemCount = $('[data-endowment-link]').size() + 1

      dynamicNumber = dynamicForm.match(
        /intervention\[endowments_attributes\]\[(\d+)\]/
      )[1]

      regExp = RegExp(dynamicNumber,"g")

      dynamicTemplate = $(dynamicForm).data().dynamicTemplate

      endowmentForm = dynamicTemplate
        .replace(regExp, itemCount)
        .replace(/dynamicContent/g, itemCount)

      tabContent.append($(endowmentForm).addClass('active'))

      $('[data-endowments-items]').append()

      $(dynamicTab.replace(/dynamicContent/g, itemCount))
        .addClass('active')
        .insertBefore('#add_new_endowment')

    @map.assignTruckMileage ||= ->
      input = $(this)

      $.ajax
        url: '/trucks'
        dataType: 'json'
        data: { q: input.val() }
        success: (data)->
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

    $(document).on 'click', '#add_new_endowment', @map.addNewTab
    $(document).on 'change', '[data-truck-number]', @map.assignTruckMileage
    $(document).on 'click', '[data-set-time-to]', @map.setCurrentTimeToTruckData
    $(document).on 'click', '#add_current_time', @map.setCurrentTimeToObservations

  unload: ->
    $(document).off 'click', '#add_new_endowment', @map.addNewTab
    $(document).off 'change', '[data-truck-number]', @map.assignTruckMileage
    $(document).off 'click', '[data-set-time-to]', @map.setCurrentTimeToTruckData
    $(document).off 'click', '#add_current_time', @map.setCurrentTimeToObservations
    
