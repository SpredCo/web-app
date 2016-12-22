$( document ).ready(function() {
    var client = algoliasearch('KGZYQKI2SD', 'a8583e100dbd3bb6e5a64d76462d1f5b');
    var index = client.initIndex('global');

    $('#aa-input-search-toto').autocomplete({hint: false, debug: true}, [
        {
            source: function (q, cb) {
                index.search(q, {hitsPerPage: 5}, function (error, content) {
                    if (error) {
                        cb([]);
                        return;
                    }
                    cb(content.hits, content);
                });
            },
            displayKey: 'name',
            templates: {
                suggestion: function (suggestion) {
                    return '<span>' + suggestion._highlightResult.name.value + '</span>' + '<span style="color: darkgray"> ' + suggestion.type + '</span>';
                }
            }
        }
    ]).on('autocomplete:selected', function (event, suggestion, dataset) {
        switch(suggestion.type) {
            case 'cast':
                window.location.replace(window.location.origin + '/casts/' + suggestion.url);
                break;
            case 'tag':
                window.location.replace(window.location.origin + '/tags/' + suggestion.name.slice(1));
                break;
            case 'user':
                window.location.replace(window.location.origin + '/' + suggestion.name);
                break;
            default:
                console.log('Unknown suggestion type: ' + suggestion.type);
        }
    })
});

window.performSearch = function() {
    var value = $('#aa-input-search').val();
    $('#aa-input-search').val('');
    window.location.replace(window.location.origin + '/search/' + value);
};

