var lastActive = false;

$(document).ready(function () {
    if ($('#tokenfield')) {
        $('#tokenfield').tokenfield({ });
    }
});

function showConversation(id) {
    if (lastActive) {
        $('#' + lastActive).removeClass('active');
    }
    $('#' + id).addClass('active');
    lastActive = id;

    $('#')
}