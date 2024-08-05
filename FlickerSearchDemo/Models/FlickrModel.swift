//
//  FlickrModel.swift
//  FlickerSearchDemo
//
//  Created by Cory Howell on 8/4/24.
//

import Foundation

struct FlickrResponse: Codable {
    let items: [FlickrImage]
}

struct FlickrImage: Codable, Identifiable {
    let id = UUID()
    let title: String
    let media: Media
    let published: Date
    let tags: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case media
        case published
        case tags
    }
}

struct Media: Codable {
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "m"
    }
}
