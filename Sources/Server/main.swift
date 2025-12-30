
import Destiny
import DestinySwiftSyntax
import HTMLKit
import HTMLKitUtilities
import Logging

// MARK: Router
struct ChessRouter {
    #declareRouter(
        routerSettings: .init(
            visibility: .package, // make the router `package` accessible
        ),
        version: .v1_1,
        dynamicNotFoundResponder: nil,
        middleware: [
            StaticMiddleware(
                handlesMethods: [HTTPStandardRequestMethod.get],
                handlesContentTypes: ["application/json", "text/html"],
                appliesStatus: 200, // ok
                appliesHeaders: [
                    "server":"destiny"
                ]
            ),
            DynamicDateMiddleware()
        ],
        Route.get(
            path: [""],
            contentType: "text/html",
            //body: ResponseBody.nonCopyableMacroExpansionWithDateHeader(#html(html(body(h1("Hello World!"))))), // problem: No macro named 'html'
            handler: { request, response in
                response.setBody(#html<StaticString> {
                    html {
                        body {
                            h1("Hello World!")
                        }
                    }
                })
            }
        ),
        Route.get(
            path: ["api", "newGame"],
            contentType: "application/json",
            handler: { request, response in
                response.setBody(StaticString(#"{"test":1}"#))
            }
        ),

        Route.get(
            path: ["api", "game", ":gameID"],
            contentType: "application/json",
            handler: { request, response in
                response.setBody(StaticString(#"{"test":2}"#))
            }
        ),
        Route.get(
            path: ["api", "game", ":gameID", "move"],
            contentType: "application/json",
            handler: { request, response in
                response.setBody(StaticString(#"{"test":3}"#))
            }
        ),

        Route.get(
            path: ["api", "evaluate", "position", ":position"],
            contentType: "application/json",
            handler: { request, response in
                response.setBody(StaticString(#"{"test":4}"#))
            }
        ),
    )
}

let server = NonCopyableHTTPServer<ChessRouter.DeclaredRouter.CompiledHTTPRouter, HTTPSocket>(
    port: 8080,
    router: ChessRouter.DeclaredRouter.router,
    logger: Logger(label: "me.randomhashtags.Chess.server")
)

// precompute and auto-update the "date" header
HTTPDateFormat.load(logger: Logger(label: "me.randomhashtags.Chess.server.dateformat"))

// run server
try await server.run()