//
//  QueueView.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/6/26.
//

import SwiftUI

struct QueueView: View {
    @State var queue:[Music]
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    HStack{
                        Text("Your Queue").font(.title)
                    }
                    HStack{
                        ScrollView{
                            ForEach(queue, id: \.id) { music in
                                HStack
                                {
                                    Button(
                                        action: {}, label: {
                                            Image(systemName: "play.circle.fill").font(.title)
                                                Text(music.title).font(.title)
                                            })
                                    Spacer()
                                    Button(role:.destructive, action: {}, label: {Label("Remove", systemImage: "trash")})
                                }.background(Color.gray.mix(with: Color.black, by: 0.6))
                            }
                        }
                    }
                    Spacer()
                    HStack{
                        Button(
                            action: {
                                Task{await AudioPlayer.shared.playQueue()}
                            },
                            label:{Label("Play Queue",systemImage: "play.circle.fill")})
                        .buttonStyle(.borderedProminent)
                    }
                }.onAppear(perform: {queue = AudioPlayer.shared.getQueue()})
            }
        }
    }
}
