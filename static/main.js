$(document).ready(() => {
    // Prevent all forms from submitting on enter.
    $("form").submit((e) => e.preventDefault())

    // Find all required elements.
    const $domain = $("#domain")
    const $domainGroup = $domain.parent()
    const $domainHelp = $domainGroup.find(".help-block")
    const $table = $("#table")
    const $graph = $("#graph")

    // Create a reusable progress bar with no adjustable state, i.e.just in progress.
    const $progressBar = $(`
    <div class="progress">
        <div class="progress-bar progress-bar-striped active"
            role="progressbar" style="width: 100%" />
    </div>`)

    // Search AJAX request.
    $("#search").click(() => {
        // Reset the status and set as in progress.
        $domainGroup.removeClass("has-success").removeClass("has-error")
        $domainHelp.text("")
        $table.empty().append($progressBar)
        $graph.empty()

        $.get(`/api/traceroute/${encodeURI($domain.val())}`)
            .done((result) => {
                const { graph, routes } = JSON.parse(result)
                $domainGroup.addClass("has-success")

                const $newTable = $(
                    '<table class="table table-bordered table-hover table-striped">'
                )

                routes.forEach((route) => {
                    $newTable.append(
                        `<tr><td>${route[0]}</td><td>${route[1]}</td></tr>`
                    )
                })

                // TODO Better error handling
                try {
                    console.log(graph)
                    d3.select("#graph").graphviz().renderDot(graph)
                } catch (e) {
                    console.error(e)
                }

                $table.empty().append($newTable)
            })
            .fail(() => {
                $domainGroup.addClass("has-error")
                $table.empty()
                $domainHelp.text("Oops, there was a problem with that domain.")
            })
    })
})
