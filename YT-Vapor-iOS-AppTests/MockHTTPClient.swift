//
//  MockHttpClient.swift
//  YT-Vapor-iOS-AppTests
//
//  Created by 山本響 on 2022/05/05.
//

import Foundation
@testable import YT_Vapor_iOS_App

final class MockHTTPClient: HTTPClientProtocol, Mockable {
    func fetch<T: Codable>(url: URL) async throws -> [T] {
        return loadJSON(filename: "SongResponse", type: T.self)
    }
    
    func sendData<T>(to url: URL, object: T, httpMethod: String) async throws where T : Decodable, T : Encodable {
        
    }
    
    func delete(at id: UUID, url: URL) async throws {
        
    }
}
