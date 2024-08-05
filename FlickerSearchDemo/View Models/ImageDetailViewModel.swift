//
//  ImageDetailViewModel.swift
//  FlickerSearchDemo
//
//  Created by Cory Howell on 8/4/24.
//

import Foundation

@MainActor
class ImageDetailViewModel: ObservableObject {
    
    @Published var imageURL: URL?
    @Published var title: String
    @Published var tags: [String]
    @Published var imageSize: CGSize = .zero
    @Published var publishDate: String
    
    private let flickrImage: FlickrImage
    
    init(flickrImage: FlickrImage) {
        self.flickrImage = flickrImage
        self.imageURL = URL(string: flickrImage.media.imageURL)
        self.title = flickrImage.title
        self.tags = flickrImage.tags.split(separator: " ").map { String($0) }
        self.publishDate = flickrImage.published.formattedDateTimeString()
    }
    
    func updateImageSize(size: CGSize) {
        self.imageSize = size
    }
}

extension Date {
    func formattedDateTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
