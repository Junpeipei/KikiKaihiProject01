//
//  ExtensionUIImage.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/11/27.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import UIKit

extension UIImage {
    func resize(width: CGFloat,height: CGFloat) -> UIImage{
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {
            assertionFailure()
            return UIImage()
        }
        UIGraphicsEndImageContext()
        
        return image
    }
}
