//
//  BaseTabBarController.swift
//  YoutubeApp
//
//  Created by Tatsushi Fukunaga on 2021/03/05.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    enum ControllerNsme: Int {
        case home, search, channel, indox, library
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewControllers()
    }
    
    private func setUpViewControllers() {
        viewControllers?.enumerated().forEach({ (index, viewController) in
            if let name = ControllerNsme.init(rawValue: index) {
                switch name {
                case .home:
                    setTabBarInfo(viewController, selectedImageName: "home-icon-red", unselectedImageName: "home-icon-black", title: "ホーム")
                case .search:
                    setTabBarInfo(viewController, selectedImageName: "search-icon-red", unselectedImageName: "search-icon-black", title: "検索")
                case .channel:
                    setTabBarInfo(viewController, selectedImageName: "channel-icon-red", unselectedImageName: "channel-icon-black", title: "登録チャンネル")
                case .indox:
                    setTabBarInfo(viewController, selectedImageName: "inbox-icon-red", unselectedImageName: "inbox-icon- black", title: "受信トレイ")
                case .library:
                    setTabBarInfo(viewController, selectedImageName: "library-icon-red", unselectedImageName: "library-icon-black", title: "ライブラリ")
                }
            }
        })
    }
    
    private func setTabBarInfo(_ viewController: UIViewController, selectedImageName: String, unselectedImageName: String, title: String) {
        
        viewController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.resize(size: .init(width: 20, height: 20))?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.image = UIImage(named: unselectedImageName)?.resize(size: .init(width: 20, height: 20))?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.title = title
        
    }
    
}
