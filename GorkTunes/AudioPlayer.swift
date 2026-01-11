//
//  AudioPlayer.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/6/26.
//

import AVFAudio
import UIKit
import MediaPlayer
import SwiftUI

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioPlayer()
    @StateObject private var musicLists = MusicLists.shared
    private var player: AVAudioPlayer?
    private var queueIsPlaying:Bool
    private override init() {
        self.queueIsPlaying = false
        super.init()
        setupAudio()
    }
    private func setupAudio(){
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
    private func remoteControlAudio(){
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let remoteControledAudio:MPRemoteCommandCenter = MPRemoteCommandCenter.shared()
        remoteControledAudio.pauseCommand.isEnabled = true
        remoteControledAudio.pauseCommand.addTarget {
            event in
            self.player?.pause()
            return .success
        }
        remoteControledAudio.playCommand.isEnabled = true
        remoteControledAudio.playCommand.addTarget{
            event in
            self.player?.play()
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
            self.nextInQueue()
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
    func prepareMusic(music:Music) async{
        do{
            await updatePlayingInfo(music: music)
            player = try AVAudioPlayer(
                contentsOf: music.URL
            )
            player?.delegate = self
            if !music.isPlaying {
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
    func addToQueue(music:Music){
        musicLists.musicQueue.append(music)
    }
    func removeFromQueue(index:Int){
        musicLists.musicQueue.remove(at: index)
    }
    func playQueue() async{
        if musicLists.musicQueue.isEmpty{
            print("no songs in queue")
            return
        }
        queueIsPlaying = true
        await prepareMusic(music: musicLists.musicQueue[0])
    }
    func togleLoopQueue(){
        if musicLists.loopQueue {
            musicLists.loopQueue = false
        }else{
            musicLists.loopQueue = true
        }
    }
    func nextInQueue() {
        if !queueIsPlaying{
            print("queue is not playing")
            return
        }
        if musicLists.musicQueue.endIndex == 1 && !musicLists.loopQueue{
            print("Stopping current Queue")
            queueIsPlaying = false
            removeFromQueue(index: 0)
            return
        }
        if musicLists.loopQueue{
            musicLists.musicQueue[0].isPlaying = false
            musicLists.musicQueue.append(musicLists.musicQueue[0])
        }
        removeFromQueue(index: 0)
        Task{
            await prepareMusic(music: musicLists.musicQueue[0])
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player?.stop()
        print("audio Finished")
        nextInQueue()
    }
}
