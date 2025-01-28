//
//  SwiftChessUI.swift
//
//
//  Created by Evan Anderson on 1/28/25.
//

// Adwaita HStack doesn't work | bruh
/*
import Adwaita
import SwiftChessUtilities

@main
struct SwiftChessUI : App {

    var app:AdwaitaApp = AdwaitaApp(id: "me.randomhashtags.Chess")

    var scene : Scene {
        Window(id: "main") {
            Content(window: $0, app: app)
        }.defaultSize(width: 1280, height: 720)
    }

    struct Content : WindowView {

        @State private var sidebarVisible:Bool = true
        @State private var width:Int = 1280
        @State private var height:Int = 720
        @State private var maximized:Bool = false

        var window:AdwaitaWindow
        var app:AdwaitaApp
        
        var view : Body {
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

        var menu : AnyView {
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
}

extension ChessBoard {
    struct View : AnyView {
        var viewContent : Body {
            HStack {
                ForEach([8,7,6,5,4,3,2,1]) { file in
                    VStack {
                        Text("FILE\(file)")
                        //HStack {
                            ForEach([1,2,3,4,5,6,7,8]) { rank in
                                Text("RANK\(rank)")
                            }
                        //}.halign(.center)
                    }
                }
            }
        }
    }
}*/