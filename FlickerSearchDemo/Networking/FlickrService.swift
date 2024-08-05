//
//  FlickrService.swift
//  FlickerSearchDemo
//
//  Created by Cory Howell on 8/4/24.
//

import Foundation

// protocol for FlickrService to facilitate dependency injection and Mock Flickr Service in unit testing
protocol FlickrServiceProtocol {
    func fetchImages(for searchTerm: String) async throws -> [FlickrImage]
}

class FlickrService: FlickrServiceProtocol {
    
    private let baseURL = "https://api.flickr.com/services/feeds/photos_public.gne"
    
    func fetchImages(for searchTerm: String) async throws -> [FlickrImage] {
        
        let cleanedSearchTerm = searchTerm
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .map { $0.filter { $0.isLetter || $0.isNumber || $0.isWhitespace } }
            .filter { !$0.isEmpty }
            .joined(separator: ",")
        
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "tags", value: cleanedSearchTerm)
        ]
        
        guard let url = urlComponents?.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let flickrResponse = try decoder.decode(FlickrResponse.self, from: data)
            return flickrResponse.items
        } catch {
            throw URLError(.cannotParseResponse)
        }
    }
}
