//
//  KikiListCustomViewCell.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/12/05.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import UIKit

class KikiListCustomViewCell: UITableViewCell{
    
    var addressLabel:UILabel!
    var titleLabel:UILabel!
    var kikiTypeLabel:UILabel!
    var registDateLabel:UILabel!
    //var newImageView:UIImageView!
    
    let mapImage = UIImage(named: "map_icon.png")?.resize(width: 40, height: 40)
    let mapButton = UIButton()

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(style:UITableViewCell.CellStyle,reuseIdentifier reuseIdenifier: String!){
        super.init(style: style, reuseIdentifier: reuseIdenifier)
        
        addressLabel = UILabel(frame: CGRect.zero)
        addressLabel.textAlignment = .left
        contentView.addSubview(addressLabel)
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)
        
        kikiTypeLabel = UILabel(frame: CGRect.zero)
        kikiTypeLabel.textAlignment = .left
        contentView.addSubview(kikiTypeLabel)
        
        registDateLabel = UILabel(frame: CGRect.zero)
        registDateLabel.textAlignment = .left
        contentView.addSubview(registDateLabel)
        
        
    }
    
    override func awakeFromNib(){
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        /*
        addressLabel.frame = CGRect(x: 60, y: 0, width: frame.width / 2, height: frame.height / 3)
        kikiTypeLabel.frame = CGRect(x: 60, y: frame.height / 3, width: frame.width / 2 - 110, height: frame.height / 3)
        registDateLabel.frame = CGRect(x: frame.width / 2, y: frame.height / 3, width: frame.width / 2, height: frame.height / 3)
        titleLabel.frame = CGRect(x: 60, y: frame.height / 3 * 2, width: frame.width / 2, height: frame.height / 3)
        */
        addressLabel.frame = CGRect(x: 75, y: 0, width: frame.width - 120, height: frame.height / 4)
        titleLabel.frame = CGRect(x: 75, y: frame.height / 4, width: frame.width - 120, height: frame.height / 4)
        kikiTypeLabel.frame = CGRect(x: 75, y: frame.height / 2, width: frame.width - 120, height: frame.height / 4)
        registDateLabel.frame = CGRect(x: 75, y: frame.height / 4  * 3, width: frame.width - 120, height: frame.height / 4)

        mapButton.frame = CGRect(x: frame.width - 80, y: frame.height / 2 - 20, width: 40, height: 40)
        mapButton.setImage(mapImage, for: .normal)
        mapButton.imageView?.contentMode = .scaleAspectFit
        mapButton.contentHorizontalAlignment = .fill
        mapButton.contentVerticalAlignment = .fill
        self.addSubview(mapButton)
        

    }
    
}
