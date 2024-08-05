//
//  ImageDetailView.swift
//  FlickerSearchDemo
//
//  Created by Cory Howell on 8/4/24.
//

import SwiftUI
import Kingfisher

struct ImageDetailView: View {
    @StateObject private var viewModel: ImageDetailViewModel
    
    init(image: FlickrImage) {
        _viewModel = StateObject(wrappedValue: ImageDetailViewModel(flickrImage: image))
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            
            if let imageURL = viewModel.imageURL {
                KFImage(imageURL)
                    .placeholder {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(1.5, anchor: .center)
                            .foregroundColor(Color.gray.opacity(0.2))
                    }
                    .onSuccess { result in
                        viewModel.updateImageSize(size: result.image.size)
                    }
                    .onFailure { error in
                        print("Error loading image: \(error)")
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .shadow(radius: 5)
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("Published: \(viewModel.publishDate)")
                    Text("Size: \(viewModel.imageSize.height.formatted()) x \(viewModel.imageSize.width.formatted())")
                }
                .font(.footnote)
                Spacer()
            }
            
            Spacer()
            TagsView(tags: viewModel.tags)
        }
        .padding()
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if let imageURL = viewModel.imageURL {
                    ShareLink(item: imageURL, subject: Text(viewModel.title)) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}



#Preview {
    let sampleImage = FlickrImage(
        title: "Sample Image",
        media: Media(imageURL: "https://via.placeholder.com/600x400"),
        published: Date(),
        tags: "sample test"
    )
    return  ImageDetailView(image: sampleImage)
}

