window.Helpers =
  getHour: ->
    now = new Date
    minutes = now.getMinutes()
    minutes = if minutes > 9 then minutes else "0#{minutes}"
    hours = now.getHours()
    hours = if hours > 9 then hours else "0#{hours}"

    hours + ':' + minutes

new Rule
  load: ->
    # For browsers with no autofocus support
    $('[autofocus]:not([readonly]):not([disabled]):visible:first').focus()
    $('[data-show-tooltip]').tooltip()

    timers = @map.timers = []

    $('.alert[data-close-after]').each (i, a)->
      timers.push setTimeout((-> $(a).alert('close')), $(a).data('close-after'))

  unload: -> clearTimeout timer for i, timer of @map.timers

jQuery ($) ->
  $(document).on 'click', 'a.submit', -> $('form').submit(); false

#  $(document).on 'ready', ->
#    interventionAlert = document.getElementById('intervention_alert')
#    source = new EventSource('/console')
#    source.addEventListener 'console', (e) ->
#      data = JSON.parse e.data
#      link = '<a href="' + data.link + '">' + data.title + '</a>'
#      interventionAlert.innerHtml = link


  $(document).ajaxStart ->
    $('#loading_caption').stop(true, true).fadeIn(100)
  .ajaxStop ->
    $('#loading_caption').stop(true, true).fadeOut(100)

  $(document).on 'submit', 'form', ->
    $(this).find('input[type="submit"], input[name="utf8"]').attr 'disabled', true
    $(this).find('a.submit').removeClass('submit').addClass('disabled')
    $(this).find('.dropdown-toggle').addClass('disabled')


  Inspector.instance().load()
