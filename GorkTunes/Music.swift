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
    
    init(URL: URL, title: String) {
        self.URL = URL
        self.title = title
    }
}
