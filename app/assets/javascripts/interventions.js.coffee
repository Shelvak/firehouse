new Rule
  load: ->
    #if $('.tab-pane.active').length == 1
    #  $('.tab-pane')
    #    .addClass('active')
    #    .attr('id', 'endowments_1')

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

      

    $('#add_new_endowment').on 'click', @map.addNewTab
    $(document).on 'change', '[data-truck-number]', @map.assignTruckMileage

  unload: ->
    $('#add_new_endowment').off 'click', @map.addNewTab
    $(document).off 'change', '[data-truck-number]', @map.assignTruckMileage
    
