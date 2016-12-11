var client = null;
var questions = [];

$(document).ready(function() {
	client = new Spred.Client();
	var castId = $("#castId").val();
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
}

function voteQuestion(way, id) {
	$('#question-' + id + '-up-btn').attr('disabled', true);
	$('#question-' + id + '-down-btn').attr('disabled', true);
	console.log('Galas');
	console.log('vote ' + way + ' question ' + id);
}

function receiveQuestion(question) {
	question.nbVote = 0;
	questions.push(question);
	const questionHtml =
		'<div id="question-' + question.id + '" class="question">' +
		'<div class="row">' +
		'<div class="col-sm-2">' +
		'<img class="question-picture" src="' + "question.user_picture" + '"/>' +
		'</div>' +
		'<div class="col-sm-8">' +
		'<div class="question-info">Posée par <a href="/@' + question.sender + '">@' + question.sender + '</a> à ' + question.date.getUTCHours() + ':' + question.date.getMinutes() + '</div>' +
		'<div class="question-content">' + question.text + '</div>' +
		'</div>' +
		'<div class="col-sm-1">' +
		'<div class="question-vote-box"><span id="question-' + question.id + '-nbvote" class="question-vote-nb">' + question.nbVote + '</span><br/><span>vote(s)</span></div>' +
		'</div>' +
		'<div class="col-sm-1" style="margin-top: 5px">' +
		'<button id="question-' + question.id + '-up-btn" class="btn btn-success question-btn-vote" onclick="voteQuestion(\'up\', ' + question.id + ');"><span class="glyphicon glyphicon-arrow-up"></span></button>' +
		'<button id="question-' + question.id + '-down-btn" class="btn btn-danger question-btn-vote" onclick="voteQuestion(\'down\', ' + question.id + ');"><span class="glyphicon glyphicon-arrow-down"></span></button>' +
		'</div>' +
		'</div>' +
		'</div>' +
		'</div>';
	$('#question-box').append(questionHtml).scrollTop($('#question-' + question.id).offset().top);
}

function receiveQuestionUp(id) {
	questions.forEach(function (q) {
		if (q.id === id) {
			q.nbVote++;
			$('#question-' + id + '-nbvote').text(q.nbVote);
			return;
		}
	});
}

function receiveQuestionDown(id) {
	questions.forEach(function (q) {
		if (q.id === id) {
			q.nbVote--;
			$('#question-' + id + '-nbvote').text(q.nbVote);
			return;
		}
	});
}

function receiveMessage(message) {
	const messageHtml =
		'<p id="message-' + message.id + '" class="message">' +
		'<a href="/@' + message.sender + '">@' + message.sender + '</a> : ' + message.text +
		'</p>';
	$('#chat-box').append(messageHtml).scrollTop($('#message-' + message.id).offset().top);
}

function simulateQuestion() {
	receiveQuestion({
		sender: 'guedj',
		date: new Date(),
		text: 'Pourquoi ?',
		id: 1
	});
}