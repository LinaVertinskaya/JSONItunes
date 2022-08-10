//
//  SearchResponse.swift
//  JSONItunes
//
//  Created by Лина Вертинская on 9.08.22.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String
    var collectionName: String?
    var artistName: String
    var artworkUrl60: String?
}
