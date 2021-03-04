//
//  Video.swift
//  YoutubeApp
//
//  Created by Tatsushi Fukunaga on 2021/03/04.
//

import Foundation

class Video: Codable {
    
    let kind: String
    let items: [Item]
    
}

class Item: Codable {
    
    let snippet: Snippet
    
}

class Snippet: Codable {
    
    let publishedAt: String
    let channelId: String
    let title: String
    let description: String
    let thumbnails: Thumbnail
    
}

class Thumbnail: Codable {
    
    let medium: ThumbnailInfo
    let high: ThumbnailInfo
    
}

class ThumbnailInfo: Codable {
    
    let url: String
    let width: Int?
    let height: Int?
    
}
