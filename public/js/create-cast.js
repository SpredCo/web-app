$(document).ready(function () {
    if ($('#tokenfield')) {
        $('#tokenfield').tokenfield({ });
    }
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