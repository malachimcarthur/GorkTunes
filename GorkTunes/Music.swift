//
//  Music.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/2/26.
//
import Foundation
import AVFoundation

final class Music{
    var URL: URL
    var title: String
    var isPlaying:Bool = false
    var metadataAsset:AVURLAsset
    init(URL: URL, title: String) {
        self.URL = URL
        self.title = title
        self.metadataAsset = AVURLAsset(url: self.URL)
    }
    func setPlaying(isPlaying:Bool) {
        self.isPlaying = isPlaying
    }
    func getArtist() async-> String?{
        do{
            
            let metaDataList = try await metadataAsset.load(.commonMetadata)
            
            for item in metaDataList {
                if item.commonKey == .commonKeyArtist{
                    return try await item.load(.stringValue)
                }
            }
            return nil
        } catch{
            print("Error while retrieving metadata \(error.localizedDescription)")
            return nil
        }
    }
    func getPlayBackDuration() async -> Double{
        do{
            return try await metadataAsset.load(.duration).seconds
        }
        catch{
            print("error getting playback")
            return 0.0
        }
    }
    func changeTitle(newTitle:String){
        
    }
    func changeArtist(newArtist:String){
        
    }
}
