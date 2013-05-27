var extend_button_div = function(){
//    $('#quick-button-div').css({ "height": $(window).height() });
    $('#show-quick-buttons').hide();
};

var apply_quick_button_functions = function(){
    $('.alarm-button').click(function(){
//        console.log($(this).attr('target'));
        switch( $(this).attr('target') ){
            case 'car_crash':
                $('#intervention_kind_a').prop('checked', true);
                break;
            case 'bike_crash':
                $('#intervention_kind_b').prop('checked', true);
                break;
            case 'bus_crash':
                $('#intervention_kind_d').prop('checked', true);
                break;
            case 'house_fire':
                $('#intervention_kind_e').prop('checked', true);
                break;
            case 'car_fire':
                $('#intervention_kind_f').prop('checked', true);
                break;
            case 'industry_fire':
                $('#intervention_kind_g').prop('checked', true);
                break;
            case 'explosion':
                $('#intervention_kind_o').prop('checked', true);
                break;
            case 'matpel':
                $('#intervention_kind_o').prop('checked', true);
                break;
            case 'person_rescue':
                $('#intervention_kind_j').prop('checked', true);
                break;
            case 'other':
                $('#intervention_kind_o').prop('checked', true);
                break;
        };
        $('#quick-button-div').slideUp(function(){
            $('#show-quick-buttons').toggle();
            window.scrollTo(0);
        });
    });

    $('#show-quick-buttons').click(function(){
        extend_button_div();
        $('#quick-button-div').slideDown();
    });
};

var setTooltips = function(){
    $('[rel*=tooltip]').tooltip();
};
