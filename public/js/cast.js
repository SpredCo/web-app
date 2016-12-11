var client = null;

$(document).ready(function() {
	client = new Spred.Client();
	var castId = $("#castId").val();
	alert(castId);
	client.on('messages', receiveMessage);
	client.on('questions', receiveQuestion);
	client.connect(castId);
});

function askQuestion() {
	const question = $('#question-input').val();
	if (question != '') {
		client.askQuestion(question);
		$('#question-input').val('');
	}
}

function sendMessage() {
	const message = $("#chat-input").val();
	if (message != '') {
		client.sendMessage(message);
	}

	function receiveQuestion(question) {
		const questionHtml =
			'<div id="question-' + question.id + '" class="question">' +
			'<div class="row">' +
			'<div class="col-sm-2">' +
			'<img class="question-picture" src="' + "question.user_picture" + '"/>' +
			'</div>' +
			'<div class="col-sm-10">' +
			'<div class="question-info">Posée par <a href="/@' + question.sender + '">@' + question.sender + '</a> à ' + question.date.getUTCHours() + ':' + question.date.getMinutes() + '</div>' +
			'<div class="question-content">' + question.text + '</div>' +
			'</div>' +
			'</div>' +
			'</div>' +
			'</div>';
		$('#question-box').append(questionHtml).scrollTop($('#question-' + question.id).offset().top);
	}

	function receiveMessage(message) {
		const messageHtml =
			'<p id="message-' + message.id + '" class="message">' +
			'<a href="/@' + message.sender + '">@' + message.sender + '</a> : ' + message.text +
			'</p>';
		$('#chat-box').append(messageHtml).scrollTop($('#message-' + message.id).offset().top);
	}
