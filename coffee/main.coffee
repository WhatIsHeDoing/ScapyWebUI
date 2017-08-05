$(document).ready ->
    # Prevent all forms from submitting on enter.
    $("form").submit (e) ->
        e.preventDefault()

    $domain = $ "#domain"
    $result = $ "#result"

    # Search AJAX request.
    $("#search").click ->
        # TODO Validate domain.
        # TODO Show loading bar.
        # TODO Use label success and failure messages instead.
        $.get("/traceroute/" + encodeURI $domain.val())
            .done((svg) ->
                # TODO Use JSON and render IP table too.
                $result.html svg)
            .fail(->
                $result.text "Oops, there was a problem with that domain.")
