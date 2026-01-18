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
                ScrollView{
                    ForEach(musicLists.playlists, id: \.id) { playlist in
                        HStack
                        {
                            Button(
                                action:{},
                                label: {Text(playlist.title).font(.title)}
                            )
                            Spacer()
                            Menu{
                                Button(
                                    action:{addToQueue(playlist: playlist)},
                                    label: {Label("Add to Queue",systemImage: "plus.circle")}
                                )
                                NavigationLink(destination: EditPlaylistView(playlist: playlist)
                                               ,label: {Label("Edit", systemImage: "pencil.circle")})
                                Button(
                                    role:.destructive,
                                    action:{
                                        modelContext.delete(playlist)
                                        updatePlaylists()
                                    },
                                    label: {
                                        Label("Remove",systemImage: "trash")
                                    })
                            }label: {Label ( "", systemImage: "ellipsis.circle")}.font(.title)
                        }.background(Color.gray.mix(with: Color.black, by: 0.6))
                    }
                }
                Spacer()
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
    private func addToQueue(playlist:Playlist){
        let queueToAdd:[Music] = playlist.musicList.shuffled()
        for music in queueToAdd{
            AudioPlayer.shared.addToQueue(music: music)
        }
    }
}


