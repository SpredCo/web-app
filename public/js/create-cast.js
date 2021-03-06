$(document).ready(function () {
    if ($('#tokenfield')) {
        $('#tokenfield').tokenfield({});
    }
    $('#date-input').pickadate({
        today: false,
        clear: false,
        formatSubmit: 'yyyy/mm/dd',
        monthsFull: ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Aout', 'Septembre', 'Octobre', 'Novembre', 'Decembre'],
        monthsShort: ['Jan', 'Fev', 'Mar', 'Avr', 'Mai', 'Jui', 'Jui', 'Aou', 'Sep', 'Oct', 'Nov', 'Dec'],
        weekdaysFull: ['Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'],
        weekdaysShort: ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam']
    });
    $('#time-input').pickatime({
        format: 'HH:i',
        clear: false
    });
    handleCastTypeSelection('#public-select');

    var tagList = $('#tag-list');

    $('.js-tag').change(function(){
        var checkBox = $(this);
        if($(this).is(':checked')){
            if (tagList.val()) {
                tagList.val(tagList.val() + ';');
            }
            tagList.val(tagList.val() + checkBox.attr('data-id'));
        } else {
            var tags = tagList.val().split(';');
            tags = tags.filter(function(tag){
                return(tag != checkBox.attr('data-id'));
            });
            var cleanValue = tags.join(';');
            tagList.val(cleanValue);
        }
    })
});

function next(current) {
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
        console.log('Invalid selected value:' + $(selected).val())
    }
}

function loadPseudoDelayed() {
    var dataList = $('#js-pseudo-list');
    var input = $('#js-autocomplete');

    dataList.empty();
    $.ajax({
        dataType: "json",
        url: '/user/search/pseudo/' + input.val(),
        success: success
    });

    function success(data) {
        console.log(data);
        data.forEach(function (user) {
            dataList.append('<option' + ' data-id=' + user.id + '>' + user.pseudo + '</option>');
        });
    }
}
var timeout = null;
function loadPseudo() {
    clearTimeout(timeout);
    timeout = setTimeout(function () {
        loadPseudoDelayed();
    }, 250);
}

function addToUserList() {
    console.log("adding user");
    var opts = $('option');
    var input = $('#js-autocomplete');

    for (var i = 0; i < opts.length; i++) {
        if (opts[i].value === input.val()) {
            console.log(opts[i].value);
            var pseudo = '@' + opts[i].value;
            var id = opts[i].attributes[0].value;
            $('#mbr-list').append('<div' + ' data-id=' + id + '>' + pseudo + '</div>');
            var idList = $('#mbr-ids');
            if (idList.val()) {
                idList.val(idList.val() + ';' + id);
            } else {
                idList.val(id);
            }
            break;
        }
    }
    input.val('');
}

function updateDateInput(enable) {
    $('#date-input').attr('disabled', !enable);
    $('#time-input').attr('disabled', !enable);
}
