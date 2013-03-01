new Rule
  load: ->
    # For browsers with no autofocus support
    $('[autofocus]:not([readonly]):not([disabled]):visible:first').focus()
    $('[data-show-tooltip]').tooltip()

    $('a[data-modal-remote]').on 'click', (e) ->
      e.preventDefault()

      $('body').append(
        '<div id="loading" class="modal">' +
        '<img src="/assets/loading.gif" max-heigth="40%" max-width="40%">' +
        '</img></div>'
      )
 
      $.ajax
        url: $(this).attr('href'),
        type: 'get'

        success: (data)->
          $('#loading').fadeOut(100, -> $(this).remove())
          $('<div class="modal hide fade">' + data + '</div>').modal(
            { backdrop: true, keyboard: true }
          ).css(
            { 'width': -> return ($(document).width() * .9) + 'px' ,
            'margin-left': -> return -($(this).width() / 2) }
          )

        error: ->
          $('#loading').find('img').slideUp()
          $('#loading').append(
            '<div class="alert alert-warning"><span>
            Ha ocurrido un error, disculpe las molestias</span></div>'
          )
          $('#loading').fadeOut(1000, -> $(this).remove())
                                                                                

    timers = @map.timers = []
    
    $('.alert[data-close-after]').each (i, a)->
      timers.push setTimeout((-> $(a).alert('close')), $(a).data('close-after'))

  unload: -> clearTimeout timer for i, timer of @map.timers

jQuery ($) ->
  $(document).on 'click', 'a.submit', -> $('form').submit(); false
  
  $(document).ajaxStart ->
    $('#loading_caption').stop(true, true).fadeIn(100)
  .ajaxStop ->
    $('#loading_caption').stop(true, true).fadeOut(100)
  
  $(document).on 'submit', 'form', ->
    $(this).find('input[type="submit"], input[name="utf8"]').attr 'disabled', true
    $(this).find('a.submit').removeClass('submit').addClass('disabled')
    $(this).find('.dropdown-toggle').addClass('disabled')


  Inspector.instance().load()
