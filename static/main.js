(function () {
    $(document).ready(function () {
        // Prevent all forms from submitting on enter.
        $("form").submit(function (e) {
            e.preventDefault();
        });

        var $domain = $("#domain");
        var $result = $("#result");

        // Search AJAX request.
        $("#search").click(function () {
            // TODO Validate domain.
            // TODO Show loading bar.
            $.get("/traceroute/" + encodeURI($domain.val()))
                // TODO Use label success and failure messages instead.
                .done(function(svg) {
                    // TODO Use JSON and render IP table too.
                    $result.html(svg);
                })
                .fail(function() {
                    $result.text("Oops, there was a problem with that domain.");
                })
        });
    });
})();
