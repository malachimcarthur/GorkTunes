//
//  MenuView.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/6/26.
//

import SwiftUI

struct MenuView: View{
    var body: some View{
        NavigationStack{
            ZStack{
                VStack{
                    HStack{
                        Text("GorkTunes").font(.title)
                    }
                    Spacer()
                    HStack{
                        NavigationLink(destination: ContentView()
                                       ,label: {Label("All Music", systemImage: "heart.fill")})
                        .font(.largeTitle)
                        .clipShape(RoundedRectangle(cornerRadius: 30,style: .continuous))
                        .background(GlassEffectContainer{
                            RoundedRectangle(cornerRadius: 30).fill(.ultraThinMaterial).glassEffect(.regular,in: .rect(cornerRadius: 12))
                        }).buttonStyle(.borderedProminent)
                    }
                    Spacer()
                    HStack{
                        NavigationLink(destination: PlaylistsView()
                                       ,label: {Label("Your Playlists", systemImage: "grid")})
                        .font(.largeTitle)
                        .background(GlassEffectContainer{
                            RoundedRectangle(cornerRadius: 30).fill(.ultraThinMaterial).glassEffect(.regular,in: .rect(cornerRadius: 12))
                        }).buttonStyle(.borderedProminent)
                    }
                    Spacer()
                    HStack{
                        NavigationLink(destination: QueueView(queue: AudioPlayer.shared.getQueue())
                                       ,label: {Label("Music Queue", systemImage: "play.circle.fill")})
                        .font(.largeTitle)
                        .background(GlassEffectContainer{
                            RoundedRectangle(cornerRadius: 30).fill(.ultraThinMaterial).glassEffect(.regular,in: .rect(cornerRadius: 12))
                        }).buttonStyle(.borderedProminent)
                    }
                    Spacer()
                    
                }
            }
        }
    }
}

