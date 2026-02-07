const DOMAIN_PATTERN = /^(?!-)([a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63}$/

export class TraceRoute extends HTMLElement {
    connectedCallback() {
        this.innerHTML = `
            <form>
                <div class="mb-4">
                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1" for="domain">
                        Domain
                    </label>
                    <div class="flex rounded-md shadow-sm">
                        <span data-addon class="inline-flex items-center rounded-l-md border border-r-0 border-gray-300 dark:border-gray-600
                                     bg-gray-50 dark:bg-gray-700 px-3 text-gray-500 dark:text-gray-400 text-sm">
                            https://
                        </span>
                        <input
                            type="text"
                            id="domain"
                            class="block w-full min-w-0 rounded-none rounded-r-md border border-gray-300 dark:border-gray-600
                                   bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 px-3 py-2
                                   focus:outline-none focus:ring-2 focus:ring-inset focus:ring-blue-500"
                            placeholder="e.g. www.duckduckgo.com"
                        />
                    </div>
                    <p class="mt-2 text-sm text-red-600 dark:text-red-400 hidden" data-help></p>
                </div>
                <button
                    id="search"
                    type="submit"
                    class="inline-flex items-center gap-2 w-full justify-center px-4 py-2
                           bg-blue-600 text-white font-medium rounded-md
                           hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500
                           focus:ring-offset-2 dark:focus:ring-offset-gray-900 transition-colors cursor-pointer
                           disabled:bg-blue-400 disabled:cursor-wait"
                >
                    <svg class="size-5" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                        <path fill-rule="evenodd" d="M9 3.5a5.5 5.5 0 1 0 0 11 5.5 5.5 0 0 0 0-11ZM2 9a7 7 0 1 1 12.452 4.391l3.328 3.329a.75.75 0 1 1-1.06 1.06l-3.329-3.328A7 7 0 0 1 2 9Z" clip-rule="evenodd" />
                    </svg>
                    <span data-label>Search</span>
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
        const addon = this.querySelector("[data-addon]")
        const help = this.querySelector("[data-help]")
        const table = this.querySelector("route-table")
        const graph = this.querySelector("route-graph")
        const form = this.querySelector("form")
        const search = this.querySelector("#search")
        const searchLabel = this.querySelector("[data-label]")

        const showError = (message) => {
            domain.classList.add(
                "border-red-500",
                "text-red-900",
                "dark:text-red-400",
                "focus:ring-red-500"
            )
            addon.classList.add(
                "border-red-500",
                "text-red-500",
                "dark:text-red-400"
            )
            help.textContent = message
            help.classList.remove("hidden")
        }

        const resetState = () => {
            domain.classList.remove(
                "border-green-500",
                "border-red-500",
                "text-red-900",
                "dark:text-red-400",
                "focus:ring-red-500"
            )
            addon.classList.remove(
                "border-red-500",
                "text-red-500",
                "dark:text-red-400"
            )
            help.classList.add("hidden")
            help.textContent = ""
        }

        form.addEventListener("submit", async (e) => {
            e.preventDefault()
            resetState()

            if (!DOMAIN_PATTERN.test(domain.value)) {
                showError("Please enter a valid domain name.")
                return
            }

            table.showLoading()
            graph.clear()

            // Disable button while in-flight.
            search.disabled = true
            searchLabel.textContent = "Searching\u2026"

            table.startTimer()

            try {
                const response = await fetch(
                    `/api/traceroute/${encodeURIComponent(domain.value)}`
                )

                if (!response.ok) throw new Error("Request failed")

                const { graph: dot, routes } = JSON.parse(await response.text())

                domain.classList.add("border-green-500")
                table.setRoutes(routes)
                graph.renderDot(dot)
            } catch {
                showError("Oops, there was a problem with that domain.")
                table.clear()
            } finally {
                search.disabled = false
                searchLabel.textContent = "Search"
            }
        })
    }
}
