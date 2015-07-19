QuickButtons = (function () {
  var
      quickButtons
    , alertButtons
    , quickButtonsClasses  = {
          open   : "buttons open-buttons"
        , closed : "buttons closed-buttons"
    }
    , quickButtonsHideText
    , quickButtonsShowText
    , quickButtonsState    = 'open'
    , quickButtonsTrigger

    , setVariables = function () {
      quickButtons         = document.getElementById("quick-buttons")
      alertButtons         = document.getElementById("alert-buttons")
      quickButtonsTrigger  = document.getElementById('buttons-trigger')
      quickButtonsShowText = quickButtonsTrigger.dataset.showText
      quickButtonsHideText = quickButtonsTrigger.dataset.hideText
    }

    , toggleButtonsTrigger = function () {
      if (quickButtonsState == 'open')
        quickButtonsTrigger.innerText = quickButtonsHideText;
      else
        quickButtonsTrigger.innerText = quickButtonsShowText;
    }

    , toggleQuickButtons = function () {
        if (quickButtonsState == 'open' ) closeButtons()
        else openButtons()

        toggleButtonsTrigger()
    }

    , openButtons = function () {
        quickButtonsState      = 'open'
        quickButtons.className = quickButtonsClasses.open
        alertButtons.className = 'alert-buttons closed'
    }

    , closeButtons = function () {
        quickButtonsState      = 'closed'
        alertButtons.className = 'alert-buttons open'
        quickButtons.className = quickButtonsClasses.closed
    }

    , bind = function () {
        setVariables()
        $('.alarm-button').click(function () {
          $('#intervention_intervention_type_id').val( $(this).attr('target') )
          $('#intervention_address').focus();
          toggleQuickButtons()

          var $self = $(this)
          if( !$self.hasClass('clicked') )
            $self.addClass("clicked").siblings().removeClass('clicked')
        });

        $('#buttons-trigger').click(function () {
          toggleQuickButtons();
        });

        $('#intervention_intervention_type_id').change(function () {
          closeButtons();
          toggleButtonsTrigger();
        });
    }

  return {
    init: bind
  }
}());
