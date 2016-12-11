var client = algoliasearch('KGZYQKI2SD', 'a8583e100dbd3bb6e5a64d76462d1f5b');
var index = client.initIndex('tags');

$('#global-search').autocomplete({hint: false}, [
    {
        source: $.fn.autocomplete.sources.hits(index, { hitsPerPage: 5 }),
        //value to be displayed in input control after user's suggestion selection
        displayKey: 'name',
        //hash of templates used when rendering dataset
        templates: {
            //'suggestion' templating function used to render a single suggestion
            suggestion: function(suggestion) {
                return '<span>' +
                    suggestion._highlightResult.name.value + '</span><span>' +
                    suggestion._highlightResult.team.value + '</span>';
            }
        }
    }
]).on('autocomplete:selected', function(event, suggestion, dataset) {
    console.log(suggestion, dataset);
});
