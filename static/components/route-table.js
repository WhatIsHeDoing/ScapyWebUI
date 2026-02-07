export class RouteTable extends HTMLElement {
    #startTime = 0

    startTimer() {
        this.#startTime = performance.now()
    }

    #formatElapsed() {
        const ms = performance.now() - this.#startTime
        return ms < 1000
            ? `Completed in ${Math.round(ms)} ms`
            : `Completed in ${(ms / 1000).toFixed(2)} s`
    }

    showLoading() {
        this.innerHTML = `
            <div class="w-full bg-gray-200 dark:bg-gray-700 rounded-full h-2 overflow-hidden">
                <div class="bg-blue-600 h-2 rounded-full animate-pulse w-full"></div>
            </div>
        `
    }

    clear() {
        this.innerHTML = ""
    }

    setRoutes(routes) {
        const table = document.createElement("table")
        table.className =
            "w-full text-sm text-left text-gray-900 dark:text-gray-100 border border-gray-200 dark:border-gray-700 rounded-md overflow-hidden"

        const thead = document.createElement("thead")
        thead.className =
            "text-xs uppercase tracking-wider text-gray-500 dark:text-gray-400 bg-gray-100 dark:bg-gray-800"
        const headerRow = document.createElement("tr")

        for (const text of ["#", "Destination", "Hop"]) {
            const th = document.createElement("th")
            th.className = "px-4 py-3 font-semibold"
            th.textContent = text
            headerRow.appendChild(th)
        }

        thead.appendChild(headerRow)
        table.appendChild(thead)

        const tbody = document.createElement("tbody")

        let index = 1
        for (const [dst, hop] of routes) {
            const tr = document.createElement("tr")
            tr.className =
                "border-b border-gray-200 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-800 even:bg-gray-50 dark:even:bg-gray-800"

            const tdNum = document.createElement("td")
            tdNum.className =
                "px-4 py-2 text-gray-400 dark:text-gray-500 tabular-nums"
            tdNum.textContent = index++

            const td1 = document.createElement("td")
            td1.className = "px-4 py-2 font-mono"
            td1.textContent = dst

            const td2 = document.createElement("td")
            td2.className = "px-4 py-2 font-mono"
            td2.textContent = hop

            tr.append(tdNum, td1, td2)
            tbody.appendChild(tr)
        }

        table.appendChild(tbody)

        const tfoot = document.createElement("tfoot")
        tfoot.className = "bg-gray-50 dark:bg-gray-800"
        const footerRow = document.createElement("tr")
        const footerCell = document.createElement("td")
        footerCell.colSpan = 3
        footerCell.className =
            "px-4 py-2 text-xs text-gray-500 dark:text-gray-400"
        footerCell.textContent = this.#formatElapsed()
        footerRow.appendChild(footerCell)
        tfoot.appendChild(footerRow)
        table.appendChild(tfoot)

        this.innerHTML = ""
        this.appendChild(table)
    }
}
