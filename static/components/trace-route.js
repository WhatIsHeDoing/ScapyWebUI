export class TraceRoute extends HTMLElement {
    connectedCallback() {
        this.innerHTML = `
            <form>
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1" for="domain">
                        Domain
                    </label>
                    <input
                        type="text"
                        id="domain"
                        class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-md shadow-sm
                               bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100
                               focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                        placeholder="e.g. www.duckduckgo.com"
                    />
                    <p class="mt-1 text-sm text-red-600 dark:text-red-400 hidden" data-help></p>
                </div>
                <button
                    id="search"
                    type="button"
                    class="w-full px-4 py-2 bg-blue-600 text-white font-medium rounded-md
                           hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500
                           focus:ring-offset-2 dark:focus:ring-offset-gray-900 transition-colors cursor-pointer
                           disabled:bg-blue-400 disabled:cursor-wait"
                >
                    Search
                </button>
            </form>

            <div class="mt-6 grid grid-cols-1 md:grid-cols-3 gap-6 items-start">
                <div class="md:col-span-1 min-w-0">
                    <route-table id="table"></route-table>
                </div>
                <div class="md:col-span-2 min-w-0 overflow-hidden">
                    <route-graph id="graph"></route-graph>
                </div>
            </div>
        `

        const domain = this.querySelector("#domain")
        const help = this.querySelector("[data-help]")
        const table = this.querySelector("route-table")
        const graph = this.querySelector("route-graph")
        const form = this.querySelector("form")
        const search = this.querySelector("#search")

        form.addEventListener("submit", (e) => e.preventDefault())

        search.addEventListener("click", async () => {
            // Reset state.
            domain.classList.remove("border-green-500", "border-red-500")
            help.classList.add("hidden")
            help.textContent = ""
            table.showLoading()
            graph.clear()

            // Disable button while in-flight.
            search.disabled = true
            search.textContent = "Searching\u2026"

            table.startTimer()

            try {
                const response = await fetch(
                    `/api/traceroute/${encodeURI(domain.value)}`
                )

                if (!response.ok) throw new Error("Request failed")

                const { graph: dot, routes } = JSON.parse(await response.text())

                domain.classList.add("border-green-500")
                table.setRoutes(routes)
                graph.renderDot(dot)
            } catch {
                domain.classList.add("border-red-500")
                table.clear()
                help.textContent = "Oops, there was a problem with that domain."
                help.classList.remove("hidden")
            } finally {
                search.disabled = false
                search.textContent = "Search"
            }
        })
    }
}
