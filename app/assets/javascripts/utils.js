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
