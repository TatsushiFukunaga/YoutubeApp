//
//  AttentionCollectionViewCell.swift
//  YoutubeApp
//
//  Created by Tatsushi Fukunaga on 2021/03/06.
//

import UIKit

class AttentionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .purple
    }
    
}
