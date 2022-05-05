//
//  SongListViewModel.swift
//  YT-Vapor-iOS-App
//
//  Created by Mikaela Caron on 10/19/21.
//

import SwiftUI

class SongListViewModel: ObservableObject {
    @Published var songs = [Song]()
    
    var httpClient: HTTPClientProtocol!
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func fetchSongs() async throws {
        let urlString = Constants.baseURL + Endpoints.songs
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let songResponse: [Song] = try await httpClient.fetch(url: url)
        
        DispatchQueue.main.async {
            self.songs = songResponse
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { i in
            guard let songID = songs[i].id else {
                return
            }
            
            guard let url = URL(string: Constants.baseURL + Endpoints.songs + "/\(songID)") else {
                return
            }
            
            Task {
                do {
                    try await httpClient.delete(at: songID, url: url)
                } catch {
                    print("❌ error: \(error)")
                }
            }
        }
        
        songs.remove(atOffsets: offsets)
    }
}
