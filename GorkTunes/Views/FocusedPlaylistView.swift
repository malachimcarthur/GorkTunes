//
//  FocusedPlaylistView.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/19/26.
//

import SwiftUI

struct FocusedPlaylistView: View {
    let playlist:Playlist
    var body : some View{
        ZStack{
            VStack{
                HStack{
                    Text(playlist.title)
                    Spacer()
                    Button(
                        action:{},
                        label: {Label(title: "Add Song", systemImage:"plus")}
                    )
                }
                Spacer()
            }
        }
    }
}
