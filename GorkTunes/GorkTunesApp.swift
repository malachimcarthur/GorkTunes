//
//  GorkTunesApp.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 12/20/25.
//

import SwiftUI
import SwiftData

@main
struct GorkTunesApp: App {
    var body: some Scene {
        WindowGroup {
            MenuView()
        }
        .modelContainer(for: [Playlist.self])
    }
}
