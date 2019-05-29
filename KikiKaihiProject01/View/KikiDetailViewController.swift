//
//  KikiDetailViewController.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/11/27.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import UIKit
import CoreLocation

protocol KikiDetailViewInterface:class{
    //var LIE:LocationInfoEntity{get set}
    
    func backMap(result:Bool) -> Void
    
}

extension KikiDetailViewController:KikiDetailViewInterface{
    //var LIE: LocationInfoEntity = LocationInfoEntity()
    
}

class KikiDetailViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    var myTableView1: UITableView!

    var LIEArray:[[String]] = [[String]]()

    var passedLocation: LocationInfoEntity!
    //var passedDocumentId: String!

    var topPadding: CGFloat = 0
    var bottomPadding: CGFloat = 0
    var leftPadding: CGFloat = 0
    var rightPadding: CGFloat = 0
    
    var screenWidth:CGFloat = 0
    var screenHeight:CGFloat = 0

    
    @IBOutlet var updateButton: KikiCustomButton!
    @IBOutlet var deleteButton: KikiCustomButton!

    
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
        
        screenWidth = view.frame.size.width
        screenHeight = view.frame.size.height

        if #available(iOS 11.0, *){
            let window = UIApplication.shared.keyWindow
            topPadding = window!.safeAreaInsets.top
            bottomPadding = window!.safeAreaInsets.bottom
            leftPadding = window!.safeAreaInsets.left
            rightPadding = window!.safeAreaInsets.right
        }
        

        //左上の閉じるボタン
        let closeBtn = UIBarButtonItem(
            title:"閉じる",
            style: .plain,
            target: self,
            action: #selector(self.cancelRegist(sender:))
        )
        self.navigationItem.setLeftBarButton(closeBtn, animated: true)
        
        updateButton = KikiCustomButton()
        updateButton.frame = CGRect(x: 10 ,y: screenHeight - bottomPadding - 100,width:screenWidth/2 - 20 ,height:50)
        updateButton.layer.cornerRadius = 10
        updateButton.setTitle("編集", for: UIControl.State.normal)
        updateButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        updateButton.backgroundColor = UIColor.init(red:60/255,green:65/255,blue:65/255,alpha:1)
        updateButton.addTarget(self, action: #selector(KikiDetailViewController.updateButtonTapped(sender:)), for: .touchUpInside)
        //updateButton.animation = "flash"
        //updateButton.duration = 0.5
        
        self.view.addSubview(updateButton)

        deleteButton = KikiCustomButton()
        deleteButton.frame = CGRect(x: screenWidth / 2 + 10 ,y: screenHeight - bottomPadding - 100,width:screenWidth/2 - 20,height:50)
        deleteButton.layer.cornerRadius = 10
        deleteButton.setTitle("削除", for: UIControl.State.normal)
        deleteButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        deleteButton.backgroundColor = UIColor.init(red:60/255,green:65/255,blue:65/255,alpha:1)
        deleteButton.addTarget(self, action: #selector(KikiDetailViewController.deleteButtonTapped(sender:)), for: .touchUpInside)
        //deleteButton.animation = "flash"
        //deleteButton.duration = 0.5
        
        self.view.addSubview(deleteButton)

        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: passedLocation.latitude, longitude: passedLocation.longitude)
        
        geocoder.reverseGeocodeLocation(location){(placemarks,error) in
            if let placemarks = placemarks{
                if let pm = placemarks.first {
                    let administrativeArea:String = pm.administrativeArea ?? ""
                    let locality:String = pm.locality ?? ""
                    let thoroughfare:String = pm.thoroughfare ?? ""

                    self.displayList(address: administrativeArea + locality + thoroughfare)
                }
            }else{
                self.displayList(address: "住所が取得できませんでした。")
            }
            
        }
        
    }
    
    @objc func updateButtonTapped(sender : AnyObject){
        let updateVC = KikiUpdateViewController()
        //modalVC.passedString = "test"
        updateVC.passedLocation = passedLocation
        //updateVC.passedDocumentId = passedDocumentId
        
        //ViewControllerをrootに
        let nav = UINavigationController(rootViewController: updateVC)
        
        //オープン
        self.present(nav,animated:true,completion: nil)
    }
    
    @objc func deleteButtonTapped(sender : AnyObject){
        let alert:UIAlertController = UIAlertController(title: "危機情報を削除します", message: "", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "はい", style: .default) { action in

            let kikiPresenter = KikiDeletePresenter(view:self,documentId:self.passedLocation.documentId ,modelType: KikiDeleteModel.self)
            kikiPresenter.deleteKiki()
            
        }
        
        let NGAction = UIAlertAction(title: "いいえ", style: .default) { action in
            print("nothing")
        }
        
        alert.addAction(OKAction)
        alert.addAction(NGAction)
        
        present(alert,animated: true,completion: nil)

    }
    
    func backMap(result:Bool) -> Void{
        if result {
            
            let alert:UIAlertController = UIAlertController(title: "削除に成功しました", message: "", preferredStyle: .alert)
            present(alert,animated: true,completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    alert.dismiss(animated: true, completion: {
                        self.dismiss(animated: true, completion: nil)
                    })
                })
            })

        }else{
            let alert:UIAlertController = UIAlertController(title: "削除に失敗しました", message: "", preferredStyle: .alert)
            present(alert,animated: true,completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    alert.dismiss(animated: true, completion: {
                        self.dismiss(animated: true, completion: nil)
                    })
                })
            })
        }
        

    }
    
    func displayList(address:String){
        let kikiType:String
        switch passedLocation.kikiType {
        case 0:
            kikiType = "動物"
        case 1:
            kikiType = "障害物"
        case 2:
            kikiType = "事件・事故"
        case 3:
            kikiType = "天災"
        case 4:
            kikiType = "その他"
        default:
            kikiType = ""
        }
        
        LIEArray = [
            ["住所",address],
            ["危機名",passedLocation.title],
            ["危機詳細",passedLocation.content],
            ["危機種別",kikiType],
            ["登録者",String(passedLocation.registUser)],
            ["登録日",passedLocation.registDate],
            ["更新日",passedLocation.updateDate]
        ]
        
        
        let rect = CGRect(x:leftPadding,
                          y:topPadding,
                          width:screenWidth - leftPadding - rightPadding,
                          height:screenHeight - topPadding - bottomPadding - 200)
        
        myTableView1 = UITableView(frame: self.view.frame, style: UITableView.Style.grouped)
        myTableView1.delegate = self
        myTableView1.dataSource = self
        myTableView1.estimatedRowHeight = 100
        myTableView1.rowHeight = UITableView.automaticDimension
        myTableView1.frame = rect
        myTableView1.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        view.addSubview(myTableView1)

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "基本情報"
        //return "第\(section)セクション"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LIEArray.count
        //return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "aaa\(indexPath.section)-\(indexPath.row)")
        
        cell.selectionStyle = .none
        cell.textLabel?.text = LIEArray[indexPath.row][0]
        cell.detailTextLabel?.text = LIEArray[indexPath.row][1]

        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func cancelRegist(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
}

