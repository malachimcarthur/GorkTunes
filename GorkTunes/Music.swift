//
//  Music.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/2/26.
//
import Foundation

final class Music{
    var URL: URL
    var title: String
    var isPlaying:Bool = false
    
    init(URL: URL, title: String) {
        self.URL = URL
        self.title = title
    }
    func setPlaying(isPlaying:Bool) {
        self.isPlaying = isPlaying
    }
}
