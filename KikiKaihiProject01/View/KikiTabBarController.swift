//
//  KikiTabBarController.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/11/29.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import UIKit

class KikiTabBarController: UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        
        //print("isUserLogin:\(isUserLoggedIn)")
        
        if(!isUserLoggedIn){
            let LoginVC = LoginViewController()
            //ViewControllerをrootに
            let nav = UINavigationController(rootViewController: LoginVC)
            //オープン
            self.present(nav,animated:true,completion: nil)
            
        }else{
            
            //タブバーの画像の色を設定
            //UITabBar.appearance().tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            UITabBar.appearance().tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            //タブバーの背景の色を指定
            //UITabBar.appearance().barTintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
            UITabBar.appearance().barTintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
            
            UITabBar.appearance().unselectedItemTintColor = UIColor.gray
            UITabBar.appearance().isTranslucent = false
            
            let topMenuController = ViewController()
            let topNavigationController = UINavigationController(rootViewController: topMenuController)
            topNavigationController.title = "Map"
            topNavigationController.tabBarItem.image = UIImage(named: "map_icon.png")?.resize(width: 25, height: 25)
            topNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0, right:0)
            
            let secondMenuController = TimelineViewController()
            let secondNavigationController = UINavigationController(rootViewController: secondMenuController)
            secondNavigationController.title = "Timeline"
            secondNavigationController.tabBarItem.image = UIImage(named: "memo_icon.png")?.resize(width: 25, height: 25)
            secondNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0, right:0)
            
            let thirdMenuController = ConfigViewController()
            let thirdNavigationController = UINavigationController(rootViewController: thirdMenuController)
            thirdNavigationController.title = "Config"
            thirdNavigationController.tabBarItem.image = UIImage(named: "config_icon.png")?.resize(width: 25, height: 25)
            thirdNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0, right:0)
            
            
            viewControllers = [topNavigationController,secondNavigationController,thirdNavigationController]
            
        }
        
    }
    
}
