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

struct ContentView: View {
    
    @State private var isPlaying = false
    @State private var musicTitle = "Monoco"
    @State private var player: AVAudioPlayer?
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20){
                Text("Gork it").font(.title)
                VStack(spacing: 20){
                    Image(systemName: (isPlaying ? "pause.circle.fill" : "play.circle.fill"))
                        .font(.largeTitle)
                        .onTapGesture {
                            isPlaying = true
                            playMusic()
                        }
                }
            }.onAppear(perform: prepareMusic)
        }
    }
    

    private func prepareMusic(){
        guard let musicFile = Bundle.main.url(forResource: musicTitle, withExtension: "mp3")
        else{
            print("Unknown Path")
            return
        }
        do{
            
            try AVAudioSession.sharedInstance()
                .setCategory(.playback,mode: .default,options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(
                contentsOf: musicFile
            )
            player?.prepareToPlay()
            print("ready to play")
        }
        catch {
            print("error in player")
        }
    }
    private func playMusic(){
        player?.play()
        print(player?.isPlaying ?? false)
    }
}
//
//  Player.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 12/29/25.
//



