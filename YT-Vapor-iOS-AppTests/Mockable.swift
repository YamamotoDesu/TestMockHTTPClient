//
//  Mockable.swift
//  YT-Vapor-iOS-AppTests
//
//  Created by 山本響 on 2022/05/05.
//

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
