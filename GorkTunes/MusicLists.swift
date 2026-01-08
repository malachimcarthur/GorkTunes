//
//  MusicLists.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/8/26.
//

import Foundation
import Combine

class MusicLists:ObservableObject{
    static let shared = MusicLists()
    @Published var fullMusicList:[Music] = []
    @Published var musicQueue:[Music]
    init() {
        self.musicQueue = []
    }
}
