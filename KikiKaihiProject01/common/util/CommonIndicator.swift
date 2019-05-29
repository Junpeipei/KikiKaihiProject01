//
//  CommonIndicator.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/12/07.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import UIKit

class CommonIndicator: UIViewController{
    
    var indicatorBackgroundView: UIView!
    
    var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    func showIndicator(){
        
        indicatorBackgroundView = UIView(frame: self.view.bounds)
        indicatorBackgroundView.backgroundColor = UIColor.black
        indicatorBackgroundView.alpha = 0.4
        indicatorBackgroundView.tag = 100100
        
        indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.center = self.view.center
        indicator.color = UIColor.white
        indicator.hidesWhenStopped = true
        
        indicatorBackgroundView?.addSubview(indicator!)
        self.view.addSubview(indicatorBackgroundView!)
        
        indicator.startAnimating()
        
    }
    
    func hideIndicator(){
                
        if let viewWithTag = self.view.viewWithTag(100100){
            viewWithTag.removeFromSuperview()
        }
    }
    
}
