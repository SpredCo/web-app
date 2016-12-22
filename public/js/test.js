$(document).ready(function () {
    // INITIALIZATION
    // ==============
    var APPLICATION_ID = 'KGZYQKI2SD';
    var SEARCH_ONLY_API_KEY = 'a8583e100dbd3bb6e5a64d76462d1f5b';

    // Client
    var algolia = algoliasearch(APPLICATION_ID, SEARCH_ONLY_API_KEY);

    // DOM and Templates binding
    var $searchInput = $('#input-tags input');
    var $searchInputIcon = $('#search-input-icon');

    // Selectize
    var selectizeKeywords = '';
    var $selectize = $searchInput.selectize({
        plugins: ['restore_on_backspace', 'remove_button'],
        choices: null,
        delimiter: ',',
        persist: false,
        create: true,
        onBlur: function () {
            toggleIconEmptyInput();
        },
        onChange: function (value) {
            selectizeKeywords = value;
            search();
        }
    })[0].selectize;

    // Initial search
    search();

    // SEARCH ALL
    // ==========
    $selectize.$control_input.on('keyup', function () {
        toggleIconEmptyInput();
        search();
    });
    function search() {
        var query = $selectize.$control_input.val();
        var tags = selectizeKeywords;

        var queries = [
            {
                indexName: 'user',
                query: query
            }
        ];
        algolia.search(queries, searchCallback);
    }

    // RENDER KEYWORDS + RESULTS
    // =========================
    function searchCallback(err, content) {
        if (err) {
            throw new Error(err);
        }

        renderKeywords(content.results[0].hits, content.results[1].facets.tags || []);
        renderHits(content.results[2]);
    }

    function renderKeywords(hits, facets) {
        var uniqueTags = selectizeKeywords.split(',');
        var values = [];
        var i;
        // Hits of dribbble_tags index
        for (i = 0; i < hits.length; ++i) {
            var hit = hits[i];
            if ($.inArray(hit.name, uniqueTags) === -1) {
                values.push({name: hit.name, cssClass: 'hit-tag'});
                uniqueTags.push(hit.name);
            }
        }
        // Facets of dribbble index
        var tags = Object.keys(facets);
        for (i = 0; i < tags.length; ++i) {
            var tag = tags[i];
            if ($.inArray(tag, uniqueTags) === -1) {
                values.push({name: tag, cssClass: 'facet-tag'});
                uniqueTags.push(tag);
            }
        }
        $keywords.html(keywordsTemplate.render({values: values.slice(0, 20)}));
    }

    function renderHits(content) {
        $hits.html(hitsTemplate.render(content));
    }

    // EVENTS BINDING
    // ==============
    $(document).on('click', '.add-tag', function (e) {
        e.preventDefault();
        $selectize.createItem($(this).data('value'), function () {});
        search();
    });
    $searchInputIcon.on('click', function (e) {
        e.preventDefault();
        $selectize.clear(false);
        $searchInput.val('').keyup().focus();
    });

    // HELPER METHODS
    // ==============
    function toggleIconEmptyInput() {
        var query = $selectize.$control_input.val() + selectizeKeywords;
        $searchInputIcon.toggleClass('empty', query.trim() !== '');
    }
});
