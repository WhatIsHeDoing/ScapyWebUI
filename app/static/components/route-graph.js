export class RouteGraph extends HTMLElement {
    connectedCallback() {
        this.style.display = "block"
        this.style.minWidth = "0"
    }

    clear() {
        this.innerHTML = ""
    }

    renderDot(dot) {
        try {
            d3.select(this)
                .graphviz()
                .width(this.clientWidth)
                .height(null)
                .fit(true)
                .renderDot(dot)
        } catch (e) {
            console.error(e)
        }
    }
}
