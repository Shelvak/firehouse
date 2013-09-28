var toggle_quick_buttons_button = function(){
    $('#show-quick-buttons').toggle();
};

var apply_quick_button_functions = function(){
    $('.alarm-button').click(function(){
        $('#intervention_intervention_type_id').val( $(this).attr('target') );
        $('#quick-button-div').slideUp(function(){
            window.scrollTo(0);
        });
        toggle_quick_buttons_button();
        $('#intervention_address').focus();

        var $self = $(this);
        if( !$self.hasClass('clicked') )
            $self.addClass("clicked").siblings().removeClass('clicked');
    });

    $('#show-quick-buttons').click(function(){
        toggle_quick_buttons_button();
        $('#quick-button-div').slideDown();
    });
};

var setTooltips = function(){
    $('[rel*=tooltip]').tooltip();
};

var setColorPicker = function(){
    $('.colorpicker').colorpicker().on('changeColor', function(ev){
        $('.add-on i').css('background-color', ev.color.toHex());
    });
};

var allowBackdropToCloseColorpicker = function(){
    $('.modal-backdrop.in').on('click', function(){
    });
};

var cleanModal = function() {
    var $modal = $('#modal');
    $modal.html('');
    $modal.removeAttr('class').removeAttr('aria-hidden').removeAttr('style');
};

var bindFunctionToModalBackdrop = function() {
    $('.modal-backdrop').bind('click', function(){
        cleanModal();
    })
};

//SrBuj ajax gem Related stuff

var highlightItem = function(method, container, element) {
    var action = method.split('_')[0];
    var $elementToHighlight = $(element);

    if(action == 'new') {
        var $container = $('#' + container);
        $elementToHighlight = $container.children().last();
        $container.append('<div id=' + method + '></div>')
    }
//todo: el color deberia elegirse.
    $elementToHighlight.effect("highlight", {color: '#bce8f1'}, 2500);
};
