# YouTube Vapor iOS App

[Video link here](https://youtu.be/2JuqhabkAT8)

# Lesson 5
Deploy the Vapor API to Heroku

JSON
```json

   
[
    {
        "title": "KILL THIS LOVE",
        "id": "cc24c93a-cc37-11ec-9d64-0242ac120002"
    },
    {
        "title": "STAY",
        "id": "d62c4a48-cc37-11ec-9d64-0242ac120002"
    }

]
```

MockableProtocol
```swift
import Foundation

protocol Mockable: AnyObject {
    var bundle: Bundle { get }
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> [T]
}

extension Mockable {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> [T] {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load the JSON file.")
        }
        
        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONDecoder().decode([T].self, from: data)
            
            return decodedObject
        } catch {
            print("❌ \(error)")
            fatalError("Failed to decode the JSON.")
        }
    }
}
```

MockHTTPClient
```swift
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

```

Unit Testing
```swift

import Combine
import XCTest
@testable import YT_Vapor_iOS_App

class SongListViewModelTests: XCTestCase {
    
    var songListVM: SongListViewModel!
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        songListVM = SongListViewModel(httpClient: MockHTTPClient())
        cancellables = []
    }
    
    override func tearDown() {
        super.tearDown()
        songListVM = nil
        cancellables = []
    }
    
    func testFetchSongSuccessfully() async throws {
        
        let expectation = XCTestExpectation(description: "Fetched Songs")
        
        try await songListVM.fetchSongs()
        
        songListVM
            .$songs
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value.count, 2)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        
    }

}
```

