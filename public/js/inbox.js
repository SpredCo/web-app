$(document).ready(function () {
    if ($('#dest')) {
        var engine = new Bloodhound({
            datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
            queryTokenizer: Bloodhound.tokenizers.whitespace,
            remote: {
                url: '/user/search/pseudo/%QUERY',
                wildcard: '%QUERY'
            }
        });

        engine.initialize();

        $('#dest').tokenfield({
            typeahead: [null, { source: engine.ttAdapter() }]
        });
    }
});