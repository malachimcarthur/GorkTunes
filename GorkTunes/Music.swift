//
//  Music.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/2/26.
//
import Foundation
import AVFoundation
import ID3TagEditor
// TODO: Change how title is collected
final class Music{
    var URL: URL
    var isPlaying:Bool = false
    var title:String = ""
    var id = UUID()
    private var metadataAsset:AVURLAsset
    private var id3TagEditor = ID3TagEditor()
    init(URL: URL) {
        self.URL = URL
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
    func getTitle() async -> String{
        do{
            var title: String?
            let metaDataList = try await metadataAsset.load(.commonMetadata)
            for item in metaDataList {
                if item.commonKey == .commonKeyTitle{
                    title = try await item.load(.stringValue)
                }
            }
            self.title = title ?? URL.lastPathComponent
            return self.title
        } catch{
            print("Error while retrieving metadata \(error.localizedDescription)")
            return URL.lastPathComponent
        }
    }
    func changeTitle(newTitle:String) async{
        do {
            if await newTitle == getTitle(){
                return
            }
            let id3Tag = try id3TagEditor.read(from: self.URL.path)
            id3Tag?.frames[.title] = ID3FrameWithStringContent(content: newTitle)
            try id3TagEditor.write(tag: id3Tag!, to: self.URL.path,andSaveTo: self.URL.path)
            print("succesfully changed the title to \(newTitle)")
        } catch{
            print("Error while changing title \(error.localizedDescription)")
        }
    }
    func changeArtist(newArtist:String){
        do {
            let id3Tag = try id3TagEditor.read(from: self.URL.path)
            id3Tag?.frames[.artist] = ID3FrameWithStringContent(content: newArtist)
            try id3TagEditor.write(tag: id3Tag!, to: self.URL.path)
            print("succesfully changed the artist to \(newArtist)")
        } catch{
            print("Error while changing title \(error.localizedDescription)")
        }
    }
}
