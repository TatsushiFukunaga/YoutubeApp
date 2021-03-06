//
//  Channel.swift
//  YoutubeApp
//
//  Created by Tatsushi Fukunaga on 2021/03/04.
//

import Foundation

class Channel: Decodable {
    
    let items: [ChannelItem]
}

class ChannelItem: Decodable {
    
    let snippet: ChannelSnippet
    
}

class ChannelSnippet: Decodable {
    
    let title: String
    let thumbnails: Thumbnail
    
}
