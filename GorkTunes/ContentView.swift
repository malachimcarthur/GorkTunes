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
    @State private var songPlaying: Music?
    @State private var musicList:[Music]?
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading){
                HStack{
                    Text("GorkTunes").font(.title)
                    Spacer()
                    Button(action: {showFileImporter = true;
                        Task{await stopPlayingMusic(lastPlayedSong: songPlaying)}}){
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
                                case .failure(let error):
                                    print("Failure to move file: \(error.localizedDescription)")
                                }
                            }
                        )
                }
                HStack{
                    VStack{
                        ScrollView{
                            ForEach(musicList ?? [], id: \.id) { music in
                                HStack
                                {
                                    Button(
                                        action: {Task {await prepareMusic(music: music)}},
                                        label: {
                                            Image(systemName: "play.circle.fill").font(.title)
                                                Text(music.title).font(.title)
                                            })
                                    Spacer()
                                    Menu{
                                        NavigationLink(destination: EditView(music: music)
                                                       ,label: {Label("Edit", systemImage: "wrench")})
                                        Button(
                                            role:.destructive,
                                            action:{
                                                Task{
                                                    await stopPlayingMusic(lastPlayedSong: songPlaying)
                                                    await Utils.deleteSong(music: music)
                                                    musicList = await Utils.createMusicObjects()
                                                }
                                            },
                                            label: {
                                                Label("Remove",systemImage: "trash")
                                            })
                                    }label: {Label ( "", systemImage: "ellipsis.circle")}.font(.title)
                                }.background(Color.gray.mix(with: Color.black, by: 0.6))
                            }
                        }
                    }
                }.onAppear(perform: {setUpAVAudio()})
                Spacer()
            }
        }.preferredColorScheme(.dark)
            .onAppear(perform: {Task{musicList = await Utils.createMusicObjects()}})
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
    private func prepareMusic(music:Music) async{
        do{
            await updatePlayingInfo(music: music)
            player = try AVAudioPlayer(
                contentsOf: music.URL
            )
            if !music.isPlaying {
                await stopPlayingMusic(lastPlayedSong: songPlaying)
                await playMusic(music: music)
            } else {
                await pauseMusic(music: music)
            }
        }
        catch {
            print("error in player \(error.localizedDescription)")
        }
    }
    private func playMusic(music:Music) async{
        player?.play()
        music.setPlaying(isPlaying: true)
        print("playing \(await music.getTitle())")
        songPlaying = music
    }
    private func pauseMusic(music:Music) async{
        player?.pause()
        music.setPlaying(isPlaying: false)
        print("pausing \(await music.getTitle())")
    }
    private func updatePlayingInfo(music:Music) async{
        let nowPlayingInfo: [String: Any] = await [
            MPMediaItemPropertyTitle: music.getTitle(),
            MPMediaItemPropertyArtist: music.getArtist() ?? "Not Given",
            MPMediaItemPropertyPlaybackDuration: music.getPlayBackDuration(),
            MPNowPlayingInfoPropertyPlaybackRate: player?.rate ?? 1.001,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: player?.currentTime ?? 0.0
        ]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    private func stopPlayingMusic(lastPlayedSong:Music?) async{
        player?.stop()
        if (lastPlayedSong == nil){
            return
        }
        lastPlayedSong?.setPlaying(isPlaying: false)
        print("Stopping \(await lastPlayedSong?.getTitle() ?? "error")")
    }
    private func remoteControlAudio(){
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let remoteControledAudio:MPRemoteCommandCenter = MPRemoteCommandCenter.shared()
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
}
