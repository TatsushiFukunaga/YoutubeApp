//
//  ViewController.swift
//  YoutubeApp
//
//  Created by Tatsushi Fukunaga on 2021/03/04.
//

import UIKit
import Alamofire

class VideoListViewController: UIViewController {
    
    @IBOutlet weak var videoListCollectionView: UICollectionView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomVideoImageView: UIImageView!
    @IBOutlet weak var bottomVideoView: UIView!
    
    private var prevContentOffset: CGPoint = .init(x: 0, y: 0)
    private var headerMoveHeight: CGFloat = 7
    
    private let cellId = "cellId"
    private let attentionCellId = "attentionCellId"
    private var videoItems = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchYoutubeSearchInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(showThumbnailImage), name: .init("thumbnailImage"), object: nil)
    }
    
    @objc private func showThumbnailImage(notification: NSNotification) {
        
        guard let userInfo = notification.userInfo as? [String: UIImage] else { return }
        let image = userInfo["image"]
        
        bottomVideoView.isHidden = false
        bottomVideoImageView.image = image
        
    }
    
    private func setupViews() {
        videoListCollectionView.delegate = self
        videoListCollectionView.dataSource = self
        
        videoListCollectionView.register(UINib(nibName: "VideoListCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        videoListCollectionView.register(AttentionCell.self, forCellWithReuseIdentifier: attentionCellId)
        
        profileImageView.layer.cornerRadius = 20
        
        bottomVideoView.isHidden = true
    }
    
    func fetchYoutubeSearchInfo() {
        let params = ["q": "messi"]
        
        API.shared.request(path: .search, params: params, type: Video.self) { (video) in
            self.videoItems = video.items
            let id = self.videoItems[0].snippet.channelId
            self.fetchYoutubeChannelInfo(id: id)
        }
    }
    
    func fetchYoutubeChannelInfo(id: String) {
        let params = ["id": id]
        
        API.shared.request(path: .channels, params: params, type: Channel.self) { (channel) in
            self.videoItems.forEach { (item) in
                item.channel = channel
            }
            
            self.videoListCollectionView.reloadData()
        }
    }
    
    // scrollViewのscrollがピタッと止まった時に呼ばれる
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            headerViewEndAnimation()
        }
    }
    
    // scrollViewのscrollが止まった時に呼ばれる
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        headerViewEndAnimation()
    }
    
    private func headerViewEndAnimation() {
        
        if headerTopConstraint.constant < -headerHeightConstraint.constant / 2 {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations: {
                
                self.headerTopConstraint.constant = -self.headerHeightConstraint.constant
                self.headerView.alpha = 0
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [], animations: {
                
                self.headerTopConstraint.constant = 0
                self.headerView.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
}

// MARK: - ScrollViewのdelegateのメソッド
extension VideoListViewController {
    
    // scrollViewがscrollした時に呼ばれるメソッド
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerAnimation(scrollView: scrollView)
    }
    
    private func headerAnimation(scrollView: UIScrollView) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.prevContentOffset = scrollView.contentOffset
        }
        guard let presentIndexPath = videoListCollectionView.indexPathForItem(at: scrollView.contentOffset) else { return }
        if scrollView.contentOffset.y < 0 { return }
        if presentIndexPath.row  >= videoItems.count - 2 { return }
        
        let alphaRatio = 1 / headerHeightConstraint.constant
        
        if self.prevContentOffset.y < scrollView.contentOffset.y {
            if headerTopConstraint.constant <= -headerHeightConstraint.constant { return }
            headerTopConstraint.constant -= headerMoveHeight
            headerView.alpha -= alphaRatio * headerMoveHeight
            
        } else if self.prevContentOffset.y > scrollView.contentOffset.y {
            if headerTopConstraint.constant >= 0 { return }
            headerTopConstraint.constant += headerMoveHeight
            headerView.alpha += alphaRatio * headerMoveHeight
        }
        
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension VideoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoViewController = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(identifier: "VideoViewController") as VideoViewController
        
        if videoItems.count == 0 {
            videoViewController.selectedItem = nil
        } else {
            //　参考演算子(if文)
            videoViewController.selectedItem = indexPath.row > 2 ? videoItems[indexPath.row - 1] : videoItems[indexPath.row]
        }
        
        bottomVideoView.isHidden = true
        self.present(videoViewController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        
        if indexPath.row == 2 {
            return .init(width: width, height: 200)
        } else {
            return .init(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoItems.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 2 {
            let cell = videoListCollectionView.dequeueReusableCell(withReuseIdentifier: attentionCellId, for: indexPath) as! AttentionCell
            cell.videoItems = self.videoItems
            return cell
        } else {
            let cell = videoListCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoListCell
            
            if self.videoItems.count == 0 { return cell }
            
            if indexPath.row > 2 {
                cell.videoItem = videoItems[indexPath.row - 1]
            } else {
                cell.videoItem = videoItems[indexPath.row]
            }
            
            return cell
        }
        
    }
    
}

