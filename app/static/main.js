import { RouteGraph } from "./components/route-graph.js"
import { RouteTable } from "./components/route-table.js"
import { TraceRoute } from "./components/trace-route.js"

customElements.define("trace-route", TraceRoute)
customElements.define("route-table", RouteTable)
customElements.define("route-graph", RouteGraph)
