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
    @State private var songPlaying: Music?
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading){
                HStack{
                    Text("GorkTunes").font(.title)
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
                            HStack
                            {
                                Button(action: {prepareMusic(music: music)})
                                {
                                    Image(systemName: (music.isPlaying ? "pause.circle.fill" : "play.circle.fill"))
                                        .font(.title)
                                    Text(music.title)
                                }//.onLongPressGesture(perform: {print("long hold")})//TODO: add settings
                            }
                            
                        }
                    }
                }.onAppear(perform: {setUpAVAudio()})
                Spacer()
            }
        }
    }
    private func setUpAVAudio(){
        do{
            try AVAudioSession.sharedInstance()
                .setCategory(.playback,mode: .default,options: [])
            try AVAudioSession.sharedInstance().setActive(true)
            remoteControlAudio()
        }
        catch{
            print("Failed to create AVAudioSession \(error.localizedDescription)")
        }
    }
    private func prepareMusic(music:Music){
        do{
            updatePlayingInfo(music: music)
            player = try AVAudioPlayer(
                contentsOf: music.URL
            )
            if !music.isPlaying {
                stopPlayingMusic(lastPlayedSong: songPlaying)
                playMusic(music: music)
            } else {
                pauseMusic(music: music)
            }
        }
        catch {
            print("error in player \(error.localizedDescription)")
        }
    }
    private func playMusic(music:Music){
        player?.play()
        music.setPlaying(isPlaying: true)
        print("playing \(music.title)")
        songPlaying = music
    }
    private func pauseMusic(music:Music){
        player?.pause()
        music.setPlaying(isPlaying: false)
        print("pausing \(music.title)")
    }
    private func updatePlayingInfo(music:Music){
        let nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: music.title,
            MPMediaItemPropertyArtist: music.artist ?? "Not Given"
        ]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    private func remoteControlAudio(){
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let remoteControledAudio = MPRemoteCommandCenter.shared()
        remoteControledAudio.pauseCommand.isEnabled = true
        remoteControledAudio.pauseCommand.addTarget {
            event in
            player?.pause()
            return .success
        }
        remoteControledAudio.playCommand.isEnabled = true
        remoteControledAudio.playCommand.addTarget{
            event in
            player?.play()
            return .success
        }
        remoteControledAudio.previousTrackCommand.isEnabled = true
        remoteControledAudio.previousTrackCommand.addTarget{
            event in
            print("success")
            return .success
        }
        remoteControledAudio.nextTrackCommand.isEnabled = true
        remoteControledAudio.nextTrackCommand.addTarget{
                event in
                print("success")
                return .success
            }

        remoteControledAudio.changePlaybackPositionCommand.isEnabled = true
        remoteControledAudio.changePlaybackPositionCommand.addTarget{
                event in
                print("success")
                return .success
            }

        remoteControledAudio.seekForwardCommand.isEnabled = true
        remoteControledAudio.seekForwardCommand.addTarget{
                event in
                print("success")
                return .success
            }
        remoteControledAudio.seekBackwardCommand.isEnabled = true
        remoteControledAudio.seekBackwardCommand.addTarget{
                event in
                print("success")
                return .success
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
    private func stopPlayingMusic(lastPlayedSong:Music?){
        if (lastPlayedSong == nil){
            return
        }
        lastPlayedSong?.setPlaying(isPlaying: false)
        print("Stopping \(lastPlayedSong?.title ?? "error")")
    }
}
