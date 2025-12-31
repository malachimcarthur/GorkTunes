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
    
    @State private var isPlaying = false
    @State private var musicTitle = "Monoco"
    @State private var player: AVAudioPlayer?
    @State private var musicDirectoryURL: URL?
    @State private var showFileImporter = false
    var body: some View {
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20){
                Text("Gork it").font(.title)
                VStack(spacing: 20){
                    Image(systemName: (isPlaying ? "pause.circle.fill" : "play.circle.fill"))
                        .font(.largeTitle)
                        .onTapGesture {
                            isPlaying ? pauseMusic() : playMusic()
                        }
                }
                VStack(spacing:30){
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .onTapGesture {
                            showFileImporter = true
                        }
                }
            }.onAppear(perform: prepareMusic)
        }.onAppear(perform: getMusicDirectory)
            .fileImporter(
                isPresented: $showFileImporter,
                allowedContentTypes: [.mp3],
                allowsMultipleSelection: true,
                onCompletion: {
                    result in
                }
            )
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
        isPlaying = true
    }
    private func pauseMusic(){
        player?.stop()
        isPlaying = false
    }
    private func getMusicDirectory(){
        do{
            let fileManager = FileManager.default
            guard let musicDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            else{
                print("No directory found")
                return
            }
            musicDirectoryURL = musicDirectory.appendingPathComponent("GorkTunesMusic", isDirectory: true)
            if !fileManager.fileExists(atPath: (musicDirectoryURL?.path())!){
                try fileManager.createDirectory(at: musicDirectoryURL ?? URL.documentsDirectory, withIntermediateDirectories: true, attributes: nil)
                print("file created at path \(musicDirectoryURL?.path() ?? "No Path")")
            }else{
                print("file exists at path \(musicDirectoryURL?.path() ?? "No Path")")
            }
        }
        catch{
            print("error in getMusic: \(error.localizedDescription)")
        }
    }
}

