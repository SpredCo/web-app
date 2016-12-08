$(document).ready(function () {
    if ($('#tokenfield')) {
        $('#tokenfield').tokenfield({ });
    }
    handleCastTypeSelection('#public-select');

    var input = document.getElementById('js-autocomplete');
    input.oninput = loadPseudo;
});

function next(current) {
    console.log('ok');
    $(current).removeClass('active');
    $(current + '-c').removeClass('in');
    $(current + '-c').removeClass('active');
    if (current == '#room') {
        $('#when').addClass('active');
        $('#when-c').addClass('in').addClass('active');
    } else if (current == '#when') {
        $('#tags').addClass('active');
        $('#tags-c').addClass('in').addClass('active');
    }
}

function prev(current) {
    $(current).removeClass('active');
    $(current + '-c').removeClass('in');
    $(current + '-c').removeClass('active');
    if (current == '#when') {
        $('#room').addClass('active');
        $('#room-c').addClass('in').addClass('active');
    } else if (current == '#tags') {
        $('#when').addClass('active');
        $('#when-c').addClass('in').addClass('active');
    }
}

function handleCastTypeSelection(selected) {
    if ($(selected).val() == 'public') {
        $('#private-cast-form').addClass('disabled-div');
        $('#public-cast-form').removeClass('disabled-div');
    } else if ($(selected).val() == 'private') {
        $('#public-cast-form').addClass('disabled-div');
        $('#private-cast-form').removeClass('disabled-div');
    } else {
        console.log('Selected value:' + $(selected).vale())
    }
}

function loadPseudo() {
    var dataList = $('#js-pseudo-list');
    var input = $('#js-autocomplete');

    $.ajax({
        dataType: "json",
        url: '/user/search/pseudo/' + input.val(),
        success: success
    });

    function success(data) {
        console.log(data);

        data.forEach(function(item) {
            var option = document.createElement('option');
            option.value = item;
            dataList.append(option);
        });
    }
}
