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
    @State private var showFileImporter = false
    @State private var fileManager = FileManager.default
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading){
                HStack{
                    Text("GorkTunes").font(.title)
                    Spacer()
                    Button(action: revealFileImporter){
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
                                    convertURLsToData(urls: urls)
                                case .failure(let error):
                                    print("Failure to move file: \(error.localizedDescription)")
                                }
                            }
                        )
                    Button(action:{print("not implemented")}){//TODO: add functionality
                        Image(systemName: "minus")
                            .imageScale(.large)
                            .font(.largeTitle)
                            .background(Color.blue)
                            .foregroundStyle(Color.white)
                            .clipShape(Circle())
                    }.buttonStyle(.borderedProminent)
                        .controlSize(.extraLarge)
                }
                HStack{
                    List{
                        ForEach(createMusicObjects(), id: \.title) { music in
                            Button(action: {prepareMusic(music: music)})
                            {
                                Image(systemName: (music.isPlaying ? "pause.circle.fill" : "play.circle.fill"))
                                    .font(.largeTitle)
                                Text(music.title).font(.largeTitle)
                            }
                            
                        }
                    }
                }
                Spacer()
            }
        }
    }
    
    
    
    private func prepareMusic(music:Music){
        do{
            try AVAudioSession.sharedInstance()
                .setCategory(.playback,mode: .default,options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(
                contentsOf: music.URL
            )
            if !music.isPlaying {
                music.setPlaying(isPlaying: true)
                player?.play()
                print("playing \(music.title)")
            } else {
                music.setPlaying(isPlaying: false)
                player?.stop()
                print("pausing \(music.title)")
            }
            
        }
        catch {
            print("error in player \(error.localizedDescription)")
        }
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
    private func listFiles(directoyURL:URL) -> [String]{
        do{
            let files = try fileManager.contentsOfDirectory(atPath: directoyURL.path())
            return files
        } catch{
            print("List files failed: \(error.localizedDescription)")
            return ["error"]
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
    private func createMusicObjects()->[Music]{
        var musicList:[Music] = []
        for file in listFiles(directoyURL: URL.documentsDirectory){
            let music = Music(URL: URL.documentsDirectory.appendingPathComponent(file),title: file.replacing(".mp3", with: ""))
            musicList.append(music)
        }
        return musicList
    }
    private func revealFileImporter(){
        showFileImporter = true
    }
}
