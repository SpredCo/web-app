$( document ).ready(function() {
    var client = algoliasearch('KGZYQKI2SD', 'a8583e100dbd3bb6e5a64d76462d1f5b');
    var index = client.initIndex('users');

    $('#aa-input-search').autocomplete({hint: false, debug: true}, [
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
                    return '<span>' + suggestion._highlightResult.pseudo.value + '</span>' + '<span style="color: darkgray"> ' + suggestion.type + '</span>';
                }
            }
        }
    ]).on('autocomplete:selected', function (event, suggestion, dataset) {
        $('#tokenfield').tokenfield('createToken', { value: suggestion.objectID, label: suggestion.pseudo });
        $('#aa-input-search').val('');
    })
});
