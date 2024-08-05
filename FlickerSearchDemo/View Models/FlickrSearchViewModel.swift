//
//  FlickrSearchViewModel.swift
//  FlickerSearchDemo
//
//  Created by Cory Howell on 8/4/24.
//

import Foundation
import Combine

@MainActor
class FlickrSearchViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var images: [FlickrImage] = []
    let navigationTitle = "Flickr Search"
    private var cancellables = Set<AnyCancellable>()
    private let flickrService: FlickrServiceProtocol
    private var searchTask: Task<Void, Never>? = nil
    
    
    init(flickrService: FlickrServiceProtocol = FlickrService()) {
        self.flickrService = flickrService
        
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchTerm in
                self?.searchImages(for: searchTerm)
            }
            .store(in: &cancellables)
    }
    
    private func searchImages(for searchTerm: String) {
        searchTask?.cancel()
        searchTask = Task {
            do {
                if !searchTerm.isEmpty {
                    self.images = try await flickrService.fetchImages(for: searchTerm)
                } else {
                    self.images = []
                }
            } catch {
                print("Error fetching images: \(error)")
                self.images = []
            }
        }
    }
}
