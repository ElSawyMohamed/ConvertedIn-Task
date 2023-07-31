//
//  NConstants.swift
//  Convertedin Task
//
//  Created by Mohamed El Sawy on 28/07/2023.
//

import Foundation

class NConstants {
            
        
    static let baseUrl: String = "https://api.themoviedb.org/3/"
    
    static let originalUrl: String = "https://image.tmdb.org/t/p/original/"
        
    // endpoints
    static let popularPeople = "person/popular"
    static let person = "person/"

    // To concatenate Base URL and Endpoint
    static func endpoint(_ endpoint: String) -> URL {
        return "\(baseUrl)\(endpoint)".url
    }
}
