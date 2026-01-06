//
//  QueueView.swift
//  GorkTunes
//
//  Created by Malachi McArthur on 1/6/26.
//

import SwiftUI

struct QueueView: View {
    var body: some View {
        NavigationStack{
            ZStack{
                VStack{
                    HStack{
                        Text("Your Queue")
                    }
                    Spacer()
                    HStack{
                        Button(
                            action: {
                                Task{await AudioPlayer.shared.playQueue()}
                            },
                            label:{Label("Play Queue",systemImage: "play.circle.fill")})
                    }
                }
            }
        }
    }
}

#Preview {
    QueueView()
}
