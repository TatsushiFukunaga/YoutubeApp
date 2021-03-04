//
//  VideoListCell.swift
//  YoutubeApp
//
//  Created by Tatsushi Fukunaga on 2021/03/04.
//

import UIKit

class VideoListCell: UICollectionViewCell {
    
    @IBOutlet weak var channelImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        channelImageView.layer.cornerRadius = 40 / 2
        
    }
    
}
