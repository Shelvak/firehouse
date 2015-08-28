QuickButtons = (function () {
  var
      quickButtons
    , alertButtons
    , quickButtonsClasses = {
          open   : "buttons open-buttons"
        , closed : "buttons closed-buttons"
    }
    , quickButtonsState   = 'open'
    , quickButtonsTrigger

    , setVariables = function () {
      quickButtons         = document.getElementById("quick-buttons")
      alertButtons         = document.getElementById("alert-buttons")
      quickButtonsTrigger  = document.getElementById('buttons-trigger')
    }

    , toggleQuickButtons = function () {
        if (quickButtonsState == 'open' )
          closeButtons()
        else
          openButtons()
    }

    , openButtons = function () {
        quickButtonsState      = 'open'
        quickButtons.className = quickButtonsClasses.open
        alertButtons.className = 'alert-buttons closed'
    }

    , closeButtons = function () {
        setVariables();
        if ( quickButtons ) {
          quickButtonsState      = 'closed';
          alertButtons.className = 'alert-buttons open';
          quickButtons.className = quickButtonsClasses.closed;
        }
    }

    , bind = function () {
        setVariables()
        $(document).on('click change', '#buttons-trigger', toggleQuickButtons)
    }

  return {
    init: bind,
    close: closeButtons
  }
}());
