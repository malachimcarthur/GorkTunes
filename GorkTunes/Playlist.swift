//
//  Playlist.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/17/26.
//

import CoreData

final class Playlist: NSManagedObject{
    var musicList:[Music] = []
    var title: String = ""
    var context: NSManagedObjectContext?
    init(entity:NSEntityDescription, insertInfo context:NSManagedObjectContext, title: String) {
        super.init(entity:entity , insertInto: context)
        self.context = context
        self.title = title
        persistentSave()
    }
    func updateTitle(title:String){
        self.title = title
        persistentSave()
    }
    func addMusic(music:Music){
        musicList.append(music)
        persistentSave()
    }
    func persistentSave(){
        if ((context?.hasChanges) != nil){
            do{
                try context?.save()
            }catch{
                print("Failed to save object: \(error.localizedDescription)")
            }
        }
    }
}
