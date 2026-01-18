//
//  Playlist.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/17/26.
//

import SwiftData

@Model
final class Playlist{
    @Attribute(.unique) var title: String = ""
    
    @Attribute(.externalStorage) var musicList:[Music]
    init(title: String) {
        self.title = title
        self.musicList = []
    }
    func updateTitle(title:String){
        self.title = title
    }
    func addMusic(music:Music){
        musicList.append(music)
    }
}
