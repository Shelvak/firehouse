var extend_button_div = function(){
    $('#quick-button-div').css({ "height": $(window).height() });
    $('#show-quick-buttons').hide();
};

var apply_quick_button_functions = function(){
    $('.alarm-button').click(function(){
        console.log($(this).attr('target'));
        switch( $(this).attr('target') ){
            case 'fire':
                $('#intervention_kind_e').prop('checked', true);
                break;
            case 'crash':
                $('#intervention_kind_a').prop('checked', true);
                break;
            case 'rescue':
                $('#intervention_kind_i').prop('checked', true);
                break;
            case 'other':
                $('#intervention_kind_o').prop('checked', true);
                break;
        };
        $('#quick-button-div').slideUp(function(){
            $('#show-quick-buttons').toggle();
        });
    });

    $('#show-quick-buttons').click(function(){
        extend_button_div();
        $('#quick-button-div').slideDown();
    });
};
