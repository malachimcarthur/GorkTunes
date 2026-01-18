//
//  EditPlaylistView.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/18/26.
//

import SwiftUI

struct EditPlaylistView: View {
    let playlist:Playlist
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
                        Text(playlist.title).font(.title).navigationBarBackButtonHidden(true)
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
                    Spacer()
                }.onAppear(perform: {
                    Task{
                        setDefaultValues()
                    }
                }).alert("Save Changes", isPresented: $showExitAlert){
                    Button("Save Changes"){
                        Task{saveChanges()}
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
    private func setDefaultValues(){
        title = playlist.title
    }
    private func saveChanges() {
        playlist.updateTitle(title: title)
    }
}
