//
//  FlickrSearchView.swift
//  FlickerSearchDemo
//
//  Created by Cory Howell on 8/4/24.
//

import SwiftUI
import Kingfisher

struct FlickrSearchView: View {
    @StateObject private var viewModel = FlickrSearchViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0, blue: 0.5157251358, alpha: 1)), Color(#colorLiteral(red: 0.009644676931, green: 0.3869022131, blue: 0.8640339971, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))]), startPoint: .top, endPoint: .center)
                    .ignoresSafeArea()
                
                ScrollView {
                    SearchBarView(text: $viewModel.searchText)
                        .padding()
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                        ForEach(viewModel.images) { image in
                            NavigationLink(destination: ImageDetailView(image: image)) {
                                if let imageURL = URL(string: image.media.imageURL) {
                                    KFImage(imageURL)
                                        .placeholder {
                                            ProgressView()
                                                .progressViewStyle(.circular)
                                                .scaleEffect(1.5, anchor: .center)
                                                .foregroundColor(Color.gray.opacity(0.2))
                                        }
                                        .onFailure { error in
                                            print("Error loading image: \(error)")
                                        }
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .shadow(radius: 5)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationTitle(viewModel.navigationTitle)
            }
        }
    }
}

#Preview {
    FlickrSearchView()
}
