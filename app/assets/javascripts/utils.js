var extend_button_div = function(){
    $('#quick-button-div').css({ "height": $(window).height() });
    $('#show-quick-buttons').hide();
};

var apply_quick_button_functions = function(){
    $('#button-fire').click(function(){
        $('#quick-button-div').slideUp(function(){
            $('#show-quick-buttons').toggle('slow');
        });
    });

    $('#show-quick-buttons').click(function(){
        extend_button_div();
        $('#quick-button-div').slideDown();
    });
};
