$(document).ready ->
    # Prevent all forms from submitting on enter.
    $("form").submit (e) ->
        e.preventDefault()

    # Find all required elements.
    $domain = $ "#domain"
    $domainGroup = $domain.parent()
    $domainHelp = $domainGroup.find(".help-block")
    $table = $ "#table"
    $graph = $ "#graph"

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
        $table.empty().append $progressBar
        $graph.empty()

        $.get("/api/traceroute/" + encodeURI $domain.val())
            .done((result) ->
                data = JSON.parse result
                $domainGroup.addClass "has-success"

                $newTable = $('<table class="table table-bordered table-hover table-striped">' +
                    ("<tr><td>#{route[0]}</td><td>#{route[1]}</td></tr>" for route in data.routes).join("") +
                    "</table>")

                try
                    d3.select("#graph").graphviz().renderDot(data.graph)
                catch
                    1

                $table.empty().append($newTable))
            .fail(->
                $domainGroup.addClass "has-error"
                $table.empty()
                $domainHelp.text "Oops, there was a problem with that domain.")
