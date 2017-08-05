$(document).ready ->
    # Prevent all forms from submitting on enter.
    $("form").submit (e) ->
        e.preventDefault()

    # Find all required elements.
    $domain = $ "#domain"
    $domainGroup = $domain.parent()
    $domainHelp = $domainGroup.find(".help-block")
    $result = $ "#result"

    # Create a reusable progress bar with no adjustable state, i.e. just in progress.
    $progressBar = $(
        '<div class="progress">' +
        '    <div class="progress-bar progress-bar-striped active" ' +
        '        role="progressbar" style="width: 100%"></div>' +
        '</div>')

    # Search AJAX request.
    $("#search").click ->
        # Reset the status and set as in progress.
        $domainGroup.removeClass("has-success").removeClass("has-error")
        $domainHelp.text ""
        $result.empty().append $progressBar

        $.get("/traceroute/" + encodeURI $domain.val())
            .done((svg) ->
                # TODO Use JSON and render IP table too.
                $domainGroup.addClass "has-success"
                $result.html svg)
            .fail(->
                $domainGroup.addClass "has-error"
                $result.empty()
                $domainHelp.text "Oops, there was a problem with that domain.")
