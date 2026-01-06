//
//  Util.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/5/26.
//


import Foundation
class Utils{
    static func listFiles(directoyURL:URL) -> [String]{
        do{
            let files:[String] = try FileManager.default.contentsOfDirectory(atPath: directoyURL.path())
            return files
        } catch{
            print("List files failed: \(error.localizedDescription)")
            return ["error"]
        }
    }
    static func createMusicObjects() async->[Music]{
        var musicList:[Music] = []
        for file in Utils.listFiles(directoyURL: URL.documentsDirectory){
            let music = Music(URL: URL.documentsDirectory.appendingPathComponent(file))
            print("Created \(await music.getTitle())")
            musicList.append(music)
        }
        return musicList
    }
    static func convertURLsToData(urls:[URL]){
        do{
            for url in urls{
                guard url.startAccessingSecurityScopedResource() else{
                    print("could not access")
                    return
                }
                let mp3Data: Data = try Data(contentsOf: url)
                addMP3DataInDocuments(data: mp3Data, MP3Name: url.lastPathComponent)
                url.stopAccessingSecurityScopedResource()
            }
        }
        catch{
            print("failed to convert files: \(error.localizedDescription)")
        }
    }
    static func addMP3DataInDocuments(data:Data,MP3Name:String){
        do{
            try data.write(to: URL.documentsDirectory.appendingPathComponent(MP3Name), options: [.atomic])
        }
        catch{
            print("Failed to write to documents: \(error.localizedDescription)")
        }
    }
    static func deleteSong(music:Music) async{
        do {
            try FileManager.default.removeItem(at: music.URL)
        }catch{
            print("Could Not Remove \(await music.getTitle()): \(error.localizedDescription)")
        }
    }
}
