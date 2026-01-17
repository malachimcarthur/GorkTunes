//
//  MusicLists.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/8/26.
//

import Foundation
import Combine
import CoreData

class MusicLists:ObservableObject{
    static let shared = MusicLists()
    @Published var fullMusicList:[Music] = []
    @Published var musicQueue:[Music]
    @Published var loopQueue:Bool
    //@Published var playlists:[Playlist]
    init() {
        self.musicQueue = []
        self.loopQueue = false
        //let fetchRequest: NSFetchRequest<Playlist> = Playlist.fetchRequest() as! NSFetchRequest<Playlist>
        //self.playlists = try! PersistentStorage.shared.context.fetch(fetchRequest)
    }
}
