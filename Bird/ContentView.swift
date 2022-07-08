//
//  ContentView.swift
//  Bird
//
//  Created by Sullivan De carli on 08/07/2022.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = BirdViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.birds) { bird in
                HStack {
                    VStack(alignment: .leading) {
                        Text(bird.name).font(.title3).bold()
                    }
                    Spacer()
                    AsyncImage(url: URL(string: bird.imageURL)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                                .frame(width: 90, height: 90, alignment: .center)
                        case .failure:
                            Color.gray
                                .clipShape(Circle())
                                .shadow(radius: 2)
                                .frame(width: 90, height: 90, alignment: .center)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }  
            }.onAppear {
                viewModel.listentoRealtimeDatabase()
            }
            .onDisappear {
                viewModel.stopListening()
            }
            .navigationTitle("Birds")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
