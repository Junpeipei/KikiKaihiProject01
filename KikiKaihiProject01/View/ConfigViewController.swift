//
//  ConfigViewController.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/11/29.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var myTableView1: UITableView!
    
    var ConfigArray:[[String]] = [[String]]()
    
    @IBOutlet var submitButton: KikiCustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let topColor = UIColor(red: 220/255, green: 225/255, blue: 225/255, alpha: 1)
        let bottomColor = UIColor(red: 240/255, green: 245/255, blue: 245/255, alpha: 1)
        let gradientColors:[CGColor] = [topColor.cgColor,bottomColor.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        */
        self.view.backgroundColor = UIColor.init(red:240/255,green:240/255,blue:240/255,alpha:1)
        
        
        //self.view.backgroundColor = UIColor.green
        
        ConfigArray = [
            ["ユーザーID",String(UserDefaults.standard.integer(forKey: "loginUser"))],
            ["モード","昼モード"]
        ]
        
        myTableView1 = UITableView(frame: self.view.frame, style: UITableView.Style.grouped)
        myTableView1.delegate = self
        myTableView1.dataSource = self
        myTableView1.estimatedRowHeight = 100
        myTableView1.rowHeight = UITableView.automaticDimension
        myTableView1.backgroundColor = UIColor.init(red:240/255,green:240/255,blue:240/255,alpha:1)
        self.view.addSubview(myTableView1)
        
        let screenWidth:CGFloat = self.view.frame.width
        let screenHeight:CGFloat = self.view.frame.height
        
        submitButton = KikiCustomButton()
        submitButton.frame = CGRect(x: screenWidth / 4 ,y:screenHeight / 2 + 100,width:screenWidth/2 ,height:50)
        submitButton.layer.cornerRadius = 10
        submitButton.setTitle("ログアウト", for: UIControl.State.normal)
        submitButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        submitButton.backgroundColor = UIColor.init(red:60/255,green:65/255,blue:65/255,alpha:1)
        submitButton.addTarget(self, action: #selector(self.loginButtonTapped(_:)), for: .touchUpInside)
        //submitButton.animation = "flash"
        //submitButton.duration = 0.5
        
        self.view.addSubview(submitButton)

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "基本情報"
        //return "第\(section)セクション"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConfigArray.count
        //return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "aaa\(indexPath.section)-\(indexPath.row)")
        
        cell.selectionStyle = .none
        cell.textLabel?.text = ConfigArray[indexPath.row][0]
        cell.detailTextLabel?.text = ConfigArray[indexPath.row][1]
        
        //cell.textLabel?.text = "セクション番号 : \(indexPath.section)"
        //cell.detailTextLabel?.text = "行番号 : \(indexPath.row)"
        //cell.imageView?.image = UIImage(named: "")
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "isUserLoggedIn")
        UserDefaults.standard.removeObject(forKey: "loginUser")
        
        let KikiTabBarVC = KikiTabBarController()
        //ViewControllerをrootに
        let nav = UINavigationController(rootViewController: KikiTabBarVC)
        
        //オープン
        self.present(nav,animated:true,completion: nil)
    }
    
    
}
