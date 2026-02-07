export class RouteGraph extends HTMLElement {
    connectedCallback() {
        this.style.display = "block"
        this.style.minWidth = "0"
    }

    clear() {
        this.innerHTML = ""
    }

    renderSvg(svg) {
        this.innerHTML = svg
        const el = this.querySelector("svg")
        if (el) {
            el.removeAttribute("width")
            el.removeAttribute("height")
            el.style.width = "100%"
            el.style.height = "auto"
        }
    }
}
