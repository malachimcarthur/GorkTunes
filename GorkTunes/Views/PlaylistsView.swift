//
//  PlaylistsView.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/6/26.
//

import SwiftUI
import CoreData
import SwiftData

struct PlaylistsView: View {
    @State private var showNewPlaylistAlert:Bool = false
    @State private var title = ""
    @StateObject private var musicLists = MusicLists.shared
    @Environment(\.modelContext) private var modelContext
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
                                let newPlaylist = Playlist(title: title)
                                modelContext.insert(newPlaylist)
                                updatePlaylists()
                            },
                            label: {Label("Create New Playlist", systemImage: "checkmark")})
                        Button(role:.cancel,action: {}, label: {Label("Cancel", systemImage: "trash")})
                    }
                }
                Spacer()
                ForEach(musicLists.playlists, id: \.id){ playlist in
                    HStack{
                        Text(playlist.title)
                    }
                }
            }
            Spacer()
        }.onAppear(perform: {
            updatePlaylists()
        })
    }
    private func updatePlaylists(){
        do{
            musicLists.playlists = try modelContext.fetch(FetchDescriptor<Playlist>())
        }catch{
            print("Failed to create playlists \(error.localizedDescription)")
        }
    }
}


