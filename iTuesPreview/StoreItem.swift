//
//  StoreItem.swift
//  iTuesPreview
//
//  Created by Serena on 2020/12/15.
//

import Foundation

struct SearchResonse: Codable{
    let resultCount: Int
    let results: [StoreItem]
}

struct StoreItem: Codable {
    let artistName: String
    let collectionCensoredName: String?
    let trackName: String
    let artistViewUrl: URL
    let collectionViewUrl: URL
    let previewUrl: URL
    let artworkUrl100: URL
    let trackPrice: Double?
}
