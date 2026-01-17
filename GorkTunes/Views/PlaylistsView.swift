//
//  PlaylistsView.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/6/26.
//

import SwiftUI
import CoreData

struct PlaylistsView: View {
    @State private var showNewPlaylistAlert:Bool = false
    @State private var title = ""
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Text("Your Playlists").font(.title)
                    Spacer()
                    Button(
                        action: {showNewPlaylistAlert = true}, label: {Label("New Playlist", systemImage: "plus.circle.fill")}
                    ).alert("Create New Playlist", isPresented: $showNewPlaylistAlert){
                        TextField("Enter Playlist Name",text:$title)
                        Button(
                            action: {
                                let entityDescription = NSEntityDescription.entity(forEntityName: title, in: PersistentStorage.shared.context)
                                _ = Playlist(entity: entityDescription!, insertInfo: PersistentStorage.shared.context, title: title)
                            },
                            label: {Label("Create New Playlist", systemImage: "checkmark")})
                        Button(role:.cancel,action: {}, label: {Label("Cancel", systemImage: "trash")})
                    }
                }
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    PlaylistsView()
}
