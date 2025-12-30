/*
// Adwaita HStack doesn't work | bruh
import Adwaita
import SwiftChessUtilities

@main
struct SwiftChessUI: App {

    var app:AdwaitaApp = AdwaitaApp(id: "me.randomhashtags.Chess")

    var scene: Scene {
        Window(id: "main") {
            Content(window: $0, app: app)
        }.defaultSize(width: 1280, height: 720)
    }
}

struct Content: WindowView {
    @State private var sidebarVisible = true
    @State private var width:Int = 1280
    @State private var height:Int = 720
    @State private var maximized = false

    var window:AdwaitaWindow
    var app:AdwaitaApp
    
    var view: Body {
        OverlaySplitView(visible: $sidebarVisible) {
            ScrollView {
            }
            .topToolbar {
                HeaderBar.end {
                    menu
                }
                .headerBarTitle {
                    WindowTitle(subtitle: "", title: "Chess")
                }
            }
        } content: {
            ChessBoard.View().topToolbar {
                HeaderBar.end {
                }
            }
        }
    }

    var menu: AnyView {
        Menu(icon: .default(icon: .openMenu)) {
            MenuButton("New Window", window: false) {
                app.addWindow("main")
            }.keyboardShortcut("n".ctrl())
            MenuButton("Quit", window: false) {
                app.quit()
            }.keyboardShortcut("q".ctrl())
        }.primary().tooltip("Main Menu")
    }

    func window(_ window: Window) -> Window {
        window.size(width: $width, height: $height).maximized($maximized)
    }
}

extension ChessBoard {
    struct View: AnyView {
        var viewContent: Body {
            HStack {
                ForEach([0,1,2,3,4,5,6,7], horizontal: true) { file in
                    VStack {
                        if let f = ChessFile(file) {
                            ForEach([1,2,3,4,5,6,7,8]) { rank in
                                Text("\(f)\(9 - rank)")
                            }
                        }
                    }.frame(minWidth: 100, minHeight: nil)
                }
            }
        }
    }
}*/