$( document ).ready(function() {
    var client = algoliasearch('KGZYQKI2SD', 'a8583e100dbd3bb6e5a64d76462d1f5b');
    var index = client.initIndex('global');

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
                    return suggestion._highlightResult.name.value;
                }
            }
        }
    ]).on('autocomplete:selected', function (event, suggestion, dataset) {
        console.log(suggestion, dataset);
    })
});
