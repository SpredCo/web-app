var qId = 0;
var mId = 0;

function askQuestion() {
    const question = $('#question-input').val();
    if (question != '') {
        console.log('Galas ici');
        console.log('Asking question: ', question);

        $('#question-input').val('');
    }
}

function receiveQuestion(question) {
    const questionHtml =
        '<div id="question-' + question.id + '" class="question">' +
        '<div class="row">' +
        '<div class="col-sm-2">' +
        '<img class="question-picture" src="' + question.user_picture + '"/>' +
        '</div>' +
        '<div class="col-sm-10">' +
        '<div class="question-info">Posée par <a href="/@' + question.user + '">@' + question.user + '</a> à ' + question.date.getUTCHours() +':' + question.date.getMinutes() + '</div>' +
        '<div class="question-content">' + question.content + '</div>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '</div>';
    $('#question-box').append(questionHtml).scrollTop($('#question-' + question.id).offset().top);
}

function simulateQuestion() {
    receiveQuestion({
        id: qId,
        user: 'guedj_m',
        user_picture: '/img/profile.jpg',
        content: 'Pourquoi ?',
        date: new Date()
    });
    ++qId;
}

function sendMessage() {
    const message = $("#chat-input").val();
    if (message != '') {
        console.log('Ici galas');
        console.log('send message :' + message);
    }
    $("#chat-input").val('');
}

function receiveMessage(message) {
    const messageHtml =
        '<p id="message-' + message.id + '" class="message">' +
        '<a href="/@' + message.user + '">@' + message.user + '</a> : ' + message.content +
        '</p>';
    $('#chat-box').append(messageHtml).scrollTop($('#message-' + message.id).offset().top);
}

function simulateMessage() {
    receiveMessage({
        id: qId,
        user: 'guedj_m',
        content: 'Bonjour',
        date: new Date()
    });
    mId++;
}