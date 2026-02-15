//
//  ContentView.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 12/20/25.
//

import SwiftUI
import SwiftData
import AVFAudio
import Foundation
import MediaPlayer

struct ContentView: View {
    @State private var player: AVAudioPlayer?
    @State private var showFileImporter:Bool = false
    @StateObject private var musicLists = MusicLists.shared
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading){
                HStack{
                    Text("All Music").font(.title)
                    Spacer()
                    Button(action: {showFileImporter = true}){
                        Image(systemName: "plus")
                            .font(.largeTitle)
                            .background(Color.blue)
                            .foregroundStyle(Color.white)
                            .font(.title)
                            .clipShape(Circle())
                    }.buttonStyle(.borderedProminent)
                        .fileImporter(
                            isPresented: $showFileImporter,
                            allowedContentTypes: [.mp3],
                            allowsMultipleSelection: true,
                            onCompletion: {
                                result in
                                switch result {
                                case .success(let urls):
                                    Utils.convertURLsToData(urls: urls)
                                    Task{
                                        await musicLists.fullMusicList = Utils.createMusicObjects()
                                    }
                                case .failure(let error):
                                    print("Failure to move file: \(error.localizedDescription)")
                                }
                            }
                        )
                }
                HStack{
                    VStack{
                        ScrollView{
                            ForEach(musicLists.fullMusicList, id: \.id) { music in
                                HStack
                                {
                                    Button(
                                        action: {Task {await AudioPlayer.shared.prepareMusic(music: music)}},
                                        label: {
                                            Image(systemName: "play.circle.fill").font(.title)
                                            Text(music.title).font(.title)
                                        })
                                    Spacer()
                                    Menu{
                                        Button(action: {AudioPlayer.shared.addToQueue(music: music)},
                                               label: {Label("Add to Queue", systemImage: "plus.circle")})
                                        NavigationLink(destination: EditView(music: music)
                                                       ,label: {Label("Edit", systemImage: "pencil.circle")})
                                        Button(
                                            role:.destructive,
                                            action:{
                                                Task{
                                                    await Utils.deleteSong(music: music)
                                                    musicLists.fullMusicList = await Utils.createMusicObjects()
                                                }
                                            },
                                            label: {
                                                Label("Remove",systemImage: "trash")
                                            })
                                    }label: {Label ( "", systemImage: "ellipsis.circle")}.font(.title)
                                }.background(Color.gray.mix(with: Color.black, by: 0.6))
                            }
                        Button(
                            action:{musicLists.musicQueue = musicLists.fullMusicList.shuffled()},
                            label: {Text("Add all to queue")}
                        )
                        }
                    }
                }
                Spacer()
            }
        }.preferredColorScheme(.dark)
            .onAppear(perform: {Task{musicLists.fullMusicList = await Utils.createMusicObjects()}})
    }
}
