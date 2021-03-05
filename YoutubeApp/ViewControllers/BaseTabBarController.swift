//
//  BaseTabBarController.swift
//  YoutubeApp
//
//  Created by Tatsushi Fukunaga on 2021/03/05.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers?.enumerated().forEach({ (index, viewController) in
            
            switch index {
            case 0:
                setTabBarInfo(viewController, selectedImageName: "home-icon-red", unselectedImageName: "home-icon-black", title: "ホーム")
            case 1:
                setTabBarInfo(viewController, selectedImageName: "search-icon-red", unselectedImageName: "search-icon-black", title: "検索")
            case 2:
                setTabBarInfo(viewController, selectedImageName: "channel-icon-red", unselectedImageName: "channel-icon-black", title: "登録チャンネル")
            case 3:
                setTabBarInfo(viewController, selectedImageName: "inbox-icon-red", unselectedImageName: "inbox-icon- black", title: "受信トレイ")
            case 4:
                setTabBarInfo(viewController, selectedImageName: "library-icon-red", unselectedImageName: "library-icon-black", title: "ライブラリ")
            default:
                break
            }
            
        })
    }
    
    private func setTabBarInfo(_ viewController: UIViewController, selectedImageName: String, unselectedImageName: String, title: String) {
        
        viewController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.resize(size: .init(width: 20, height: 20))?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.image = UIImage(named: unselectedImageName)?.resize(size: .init(width: 20, height: 20))?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.title = title
        
    }
    
}
