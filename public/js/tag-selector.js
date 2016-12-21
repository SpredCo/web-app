$(function() {
    $('#input-tags').selectize({
        plugins: ['remove_button'],
        delimiter: ',',
        persist: false
    });
});

var endRegister = function() {
    var tags = Array.from($('.item')).map(function(item) {
        return item.dataset.value;
    });
    console.log(JSON.stringify(tags));
    $.ajax({
        type: "POST",
        dataType: "application/json",
        url: '/signup-step3',
        data: {tags: tags},
        success: success
    });
    window.location.replace(window.location.origin);

    function success() {
        console('Register tags ok');
    }
};
