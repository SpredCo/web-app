var client = null;

$(document).keypress(function(e) {
	if (e.which == 13) {
		$(".js-send-button:visible").click();
	}
});

$(document).ready(function() {
	client = new Spred.Client();
	var castId = $("#castId").val();
	var castToken = $("#castToken").val();

	client.on('ready', function() {
		if (client.isPresenter) {
			var startButton = $('#start_cast');
			var terminateButton = $('#terminate_cast');
			var deleteButton = $('#delete_cast');
			startButton.removeClass('disabled');

			startButton.click(function() {
				client.start();
				$("#cast-image").addClass('hidden');
				$("#video").removeClass('hidden');
				$("#question-tab").removeClass('hidden');
				$("#chat-tab").removeClass('hidden');
				startButton.addClass('hidden');
				deleteButton.addClass('hidden');
				terminateButton.removeClass('hidden');
			});

			terminateButton.click(function() {
				client.quit();
			});
		} else {
			client.start();
		}
	});
	if (!castToken) {
		client.on('messages', receiveMessage);
		client.on('questions', receiveQuestion);
		client.on('up_question', updateQuestions);
		client.on('down_question', updateQuestions);
		client.on('user_joined', updateUser);
		client.on('user_left', updateUser);
		client.on('error', displayErrors);
		client.on('presenter_left', displayErrors);
		client.on('reload_cast', removeErrors);
		client.on('cast_terminated', function() {
			if (client.castToken && client.castToken.presenter) {
				window.location.replace("/profile");
			}
		});
	}
	client.connect({
		castId: castId,
		castToken: castToken
	});
	var sourceDropdown = $('#source_dropdown');
	sourceDropdown.tooltip();
	disableSourceDropdown();
});

function removeErrors() {
	var isHidden = $('#alert-box').hasClass('hidden');
	if (!isHidden) {
		$('#alert-box').addClass('hidden');
	}
}

function displayErrors(error) {
	$('#alert-box').removeClass('hidden');
	$('#alert-box-content').html(error.message);
}

function disableSourceDropdown() {
	var sourceDropdown = $('#source_dropdown');
	sourceDropdown.addClass('disabled');
	sourceDropdown.attr('title', 'Veuillez patienter pendant le changement de source...');
	setTimeout(function() {
		$('#source_dropdown').removeClass('disabled');
		sourceDropdown.attr('title', '');
	}, 10000);
}

function changeSource(source) {
	client.setSource(source);
	disableSourceDropdown();
}

function updateUser(spredCast) {
	var users_count = $('#user_count');

	users_count.html(spredCast.nbUsers);
}

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
		$("#chat-input").val('');
	}
}

function voteQuestion(way, id) {
	$('#question-' + id + '-up-btn').attr('disabled', true);
	$('#question-' + id + '-down-btn').attr('disabled', true);
	client.spredCast.questions.forEach(function(q) {
		if (q.id === id) {
			if (way === 'up') q.up();
			else q.down();
			return;
		}
	});
}

function receiveQuestion(question) {
	if (question) {
		client.sendNotification(question);
		updateQuestions();
	}
}

function updateQuestions() {
	var questionsHtml = "";
	client.spredCast.questions.forEach(function(question) {
		var isDisabled = question.alreadyVoted ? 'disabled' : '';
		const questionHtml =
			'<div id="question-' + question.id + '" class="question">' +
			'<div class="row">' +
			'<div class="col-sm-2">' +
			'<img class="question-picture" src="' + question.user_picture + '"/>' +
			'</div>' +
			'<div class="col-sm-8">' +
			'<div class="question-info">Posée par <a href="/@' + question.sender + '">@' + question.sender + '</a> à ' + question.date.getUTCHours() + ':' + question.date.getMinutes() + '</div>' +
			'<div class="question-content">' + question.text + '</div>' +
			'</div>' +
			'<div class="col-sm-1">' +
			'<div class="question-vote-box"><span id="question-' + question.id + '-nbvote" class="question-vote-nb">' + question.nbVote + '</span><br/><span>vote(s)</span></div>' +
			'</div>' +
			'<div class="col-sm-1" style="margin-top: 5px">' +
			'<button id="question-' + question.id + '-up-btn" ' + isDisabled + ' " class="btn btn-success question-btn-vote" onclick="voteQuestion(\'up\', ' + question.id + ');"><span class="glyphicon glyphicon-arrow-up"></span></button>' +
			'<button id="question-' + question.id + '-down-btn" ' + isDisabled + ' " class="btn btn-danger question-btn-vote" onclick="voteQuestion(\'down\', ' + question.id + ');"><span class="glyphicon glyphicon-arrow-down"></span></button>' +
			'</div>' +
			'</div>' +
			'</div>' +
			'</div>';
		questionsHtml = questionsHtml.concat(questionHtml);
	});
	$('#question-box').html(questionsHtml);
}

function receiveMessage(message) {
	client.sendNotification(message);
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
