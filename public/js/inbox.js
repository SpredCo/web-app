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
    if (!($('#' + id).attr('data-reply'))) {
        $("#reply-link").addClass('disabled');
    } else {
        $("#reply-link").removeClass('disabled');
    }
    $("#reply-link").attr('href', '/inbox/conversation/' + id + '/reply');
    $('#conversation-content').html('');
    $('#loading').css('display', 'inherit');
    $.get('/inbox/conversation/' + id, function (data) {
        $('#loading').css('display', 'none');
        $('#conversation-content').html(data);
        if ($('#' + id + '-read')) {
            $('#' + id + '-read').css('opacity', '0');
        }
        setTimeout(function () {
            document.getElementById("inbox-content").scrollTop = document.getElementById("inbox-content").scrollHeight;
            if ($('.unread-msg')) {
                var unreadCount = $('.unread-msg').length;
                var cUnread = parseInt($('#unread-count').text());
                $('#unread-count').text(cUnread - unreadCount);
                if (cUnread - unreadCount === 0) {
                    $('#unread-count').removeClass('active');
                }
            }
        }, 50);
    });
}