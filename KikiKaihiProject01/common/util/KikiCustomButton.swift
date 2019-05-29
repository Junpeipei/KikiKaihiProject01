//
//  KikiCustomButton.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/12/07.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import UIKit

extension KikiCustomButton{
    
    internal func commonInit(){
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1.0
    }
    
    internal func touchStartAnimation(){
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95);
            self.alpha = 0.9
        }, completion: nil)
    }
    
    internal func touchEndAnimation(){
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {() -> Void in
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.alpha = 1
        }, completion: nil)
    }
    
}

class KikiCustomButton:UIButton{
    
    override init(frame:CGRect){
        super.init(frame:frame)
        commonInit()
    }
    
    required init?(coder aDecorder: NSCoder){
        super.init(coder:aDecorder)
        commonInit()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touchStartAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchEndAnimation()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touchEndAnimation()
    }
    
}
