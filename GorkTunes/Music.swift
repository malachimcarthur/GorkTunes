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
    var artist: String?
    
    init(URL: URL, title: String) {
        self.URL = URL
        self.title = title
        self.artist = "danny Devito"
    }
    func setPlaying(isPlaying:Bool) {
        self.isPlaying = isPlaying
    }
    func getArtist() async-> String?{
        do{
            let file = AVURLAsset(url: self.URL)
            let metaDataList = try await file.load(.commonMetadata)
            
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
}
