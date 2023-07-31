//
//  ImageList.swift
//  Convertedin Task
//
//  Created by Mohamed El Sawy on 31/07/2023.
//

import Foundation

// MARK: - ImageList
struct ImageList: Codable {
    
    let id: Int?
    let profiles: [Profile]?
    let statusCode: Int?
    let statusMessage: String?
    let success: Bool?
     
    enum CodingKeys: String, CodingKey {
        case id, profiles
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case success
    }
}

// MARK: - Profile
struct Profile: Codable {
    let aspectRatio: Double
    let height: Int
    let iso639_1: String?
    let filePath: String
    let voteAverage: Double
    let voteCount, width: Int

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case height
        case iso639_1 = "iso_639_1"
        case filePath = "file_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}
