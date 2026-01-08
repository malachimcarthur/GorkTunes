//
//  EditView.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/5/26.
//

import SwiftUI

struct EditView: View {
    let music:Music
    @State private var title = ""
    @State private var artist = ""
    @State private var showExitAlert = false
    @StateObject private var musicLists = MusicLists()
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    HStack{
                        Text(music.URL.lastPathComponent).font(.title).navigationBarBackButtonHidden(true)
                        Spacer()
                    }.padding()
                    VStack{
                        HStack{
                            Text("Title").opacity(0.6).font(.subheadline)
                            Spacer()
                        }
                        HStack{
                            TextField("Enter Title", text: $title).textFieldStyle(.roundedBorder)
                        }
                    }
                    VStack{
                        HStack{
                            Text("Artist").opacity(0.6).font(.subheadline)
                            Spacer()
                        }
                        HStack{
                            TextField("Enter Artist", text: $artist).textFieldStyle(.roundedBorder)
                        }
                        Spacer()
                    }
                    Spacer()
                }.onAppear(perform: {
                    Task{
                        await setDefaultValues()
                    }
                }).alert("Save Changes", isPresented: $showExitAlert){
                    Button("Save Changes"){
                        Task{await saveChanges()}
                        print("Saved")
                        dismiss()
                    }
                    Button("Exit without Saving", role: .destructive){
                        print("Did not save")
                        dismiss()
                    }
                }
                Spacer()
            }
        }.toolbar{
            ToolbarItem(placement: .topBarLeading){
                Button(action: {showExitAlert = true}, label: {Label("Back Button", systemImage: "arrow.left")})
            }
        }
    }
    private func setDefaultValues() async{
        title = await music.getTitle()
        artist = await music.getArtist() ?? ""
    }
    private func saveChanges() async {
        music.changeArtist(newArtist: artist)
        await music.changeTitle(newTitle: title)
        musicLists.fullMusicList = await Utils.createMusicObjects()
    }
}
