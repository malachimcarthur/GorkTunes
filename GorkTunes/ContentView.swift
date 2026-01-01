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
    @State private var player: AVAudioPlayer?
    @State private var showFileImporter = false
    @State private var fileManager = FileManager.default
    var body: some View {
        VStack(){
            HStack{
                Text("GorkTunes")
                    .font(.title)
                Spacer()
                Image(systemName: "plus")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Circle())
                    .onTapGesture {
                        showFileImporter = true
                    }
                    .fileImporter(
                        isPresented: $showFileImporter,
                        allowedContentTypes: [.mp3],
                        allowsMultipleSelection: true,
                        onCompletion: {
                            result in
                            switch result {
                            case .success(let urls):
                                convertURLsToData(urls: urls)
                            case .failure(let error):
                                print("Failure to move file: \(error.localizedDescription)")
                            }
                        }
                    )
            }
        }.padding(.top)
        ZStack{
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20){
                Image(systemName: (isPlaying ? "pause.circle.fill" : "play.circle.fill"))
                    .font(.largeTitle)
                    .onTapGesture {
                        
                    }
            }
        }
    }
    
    
    
    private func prepareMusic(musicTitle:String){
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
            playMusic()
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
    private func convertURLsToData(urls:[URL]){
        do{
            for url in urls{
                guard url.startAccessingSecurityScopedResource() else{
                    print("could not access")
                    return
                }
                let mp3Data = try Data(contentsOf: url)
                addMP3DataInDocuments(data: mp3Data, MP3Name: url.lastPathComponent)
                url.stopAccessingSecurityScopedResource()
            }
        }
        catch{
            print("failed to convert files: \(error.localizedDescription)")
        }
    }
    private func listFiles(directoyURL:URL){
        do{
            let files = try fileManager.contentsOfDirectory(atPath: directoyURL.path())
            print("Here are the files: \(files)")
        } catch{
            print("List files failed: \(error.localizedDescription)")
        }
    }
    private func addMP3DataInDocuments(data:Data,MP3Name:String){
        do{
            try data.write(to: URL.documentsDirectory.appendingPathComponent(MP3Name), options: [.atomic])
            print("success: \(listFiles(directoyURL: URL.documentsDirectory))")
        }
        catch{
            print("Failed to write to documents: \(error.localizedDescription)")
        }
    }
}
