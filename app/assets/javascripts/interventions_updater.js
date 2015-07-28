var InterventionUpdater = ( function () {
  var socket
    , timeout = 1500

    , setupSocket = function () {
        socket = io('http://localhost:8085')
    }
    , listenToUpdates = function () {
        setupSocket()
        socket.on('update interventions', function (data) {
          var message = 'Han habido cambios en las intervenciones, acutalizando página'
          showMessage(message)
          setTimeout(refreshPage, timeout)
        });
    }
    , emitEvent = function (event, incomingMessage) {
        setupSocket()
        var message = incomingMessage || 'Hay una nueva intervención en el sistema.'
        if (event == 'new intervention') socket.emit(event, { message: message })
    }
    , showMessage = function (message) {
        var alertDiv = document.querySelector('[rel="alerts"]')
        alertDiv.className = 'alert alert-warning'
        alertDiv.innerHTML = message
    }
    , refreshPage = function () {
        window.location.reload()
    }
  return {
      update    : listenToUpdates
    , emitEvent : emitEvent
  }
} () )
