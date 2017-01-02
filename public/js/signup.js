// Load the SDK asynchronously
(function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

window.fbAsyncInit = function() {
    FB.init({
        appId: '565509136962999',
        cookie: true,
        xfbml: true,
        version: 'v2.7'
    });
};

function fbLogin() {
    FB.login(function (responses) {
        if (responses.authResponse) {
            $('#signup-type').val('facebook_token');
            $('#token').val(responses.authResponse.accessToken);
            $('#token-form').submit();
        }
    }, {
        'scope': 'email'
    });
}

function attachSignin(element) {
    auth2.attachClickHandler(element, {},
        function(googleUser) {
            $('#signup-type').val('google_token');
            $('#token').val(googleUser.Zi.access_token);
            $('#token-form').submit();
        }, function(error) {
        });
}

$(document).ready(function () {
    gapi.load('auth2', function() {
        // Retrieve the singleton for the GoogleAuth library and set up the client.
        auth2 = gapi.auth2.init({
            client_id: '220029720276-eg21k8f0ui6ephhh6n0ec6o3il6oip1l.apps.googleusercontent.com'
        });
        attachSignin(document.getElementById('googleLogin'));
    });
});
