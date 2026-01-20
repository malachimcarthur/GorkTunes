//
//  FocusedPlaylistView.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/19/26.
//

import SwiftUI

struct FocusedPlaylistView: View {
    let playlist:Playlist
    @StateObject private var musicList:MusicLists = MusicLists.shared
    var body : some View{
        ZStack{
            VStack{
                HStack{
                    Text(playlist.title)
                    Spacer()
                    Menu{
                        ForEach(musicList.fullMusicList, id:\.title){music in
                            Button (
                                action:{playlist.addMusic(music: music)},
                                label:{Text(music.title)}
                            )
                        }
                    }label: {Label("Add Song", systemImage:"plus")}
                }
                ForEach(playlist.musicList.enumerated(), id: \.offset){index,music in
                    HStack{
                        Text(music.title)
                        Spacer()
                        Button (role: .destructive,
                                action: {playlist.removeMusic(index: index)},
                                label: {Label("remove", systemImage: "trash")}
                        )
                    }
                }
                Spacer()
            }
        }
    }
}
