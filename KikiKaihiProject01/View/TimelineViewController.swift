//
//  TimelineViewController.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/11/29.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import UIKit
import CoreLocation

protocol TimelineViewInterface:class{
    //var LIE:LocationInfoEntity{get set}
    //func displayList(LIEArray:[LocationInfoEntity],documentIdList:[String]) -> Void
    
    func displayList(LIEArray:[LocationInfoEntity]) -> Void
    
    func displayNon() -> Void
    
}

extension TimelineViewController:TimelineViewInterface{
    //var LIE: LocationInfoEntity = LocationInfoEntity()
    
}


class TimelineViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var myTableView1: UITableView!
    
    var ListArray:[[String]] = [[String]]()
    var LIEArray:[LocationInfoEntity]!
    
    let compareSecond:Double = 60*60*24*3
    
    let now:Date = Date()
    
    //let indicator = CommonIndicator()
    
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
        
        //indicator.showIndicator()
        
        let kikiPresenter:KikiSearchPresenterInterface = KikiSearchPresenter(view:self,modelType: KikiSearchModel.self)
        
        kikiPresenter.getKikiOrderByYmd()
        //self.view.backgroundColor = UIColor.blue
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "危機情報"
        //return "第\(section)セクション"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListArray.count
        //return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(KikiListCustomViewCell.self),for: indexPath) as! KikiListCustomViewCell
        
        cell.accessoryType = .disclosureIndicator
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let updateDate = dateFormatter.date(from: ListArray[indexPath.row][3])
        let span = now.timeIntervalSince(updateDate!)
        
        cell.imageView?.image = nil
        
        if span <= compareSecond {
            cell.imageView?.image = UIImage(named: "new.png")?.resize(width: 40, height: 40)
        }
        
        let kikiType:String
        switch Int(ListArray[indexPath.row][2]) {
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
        
        cell.selectionStyle = .none
        cell.addressLabel.text = "場所　　：" + ListArray[indexPath.row][0]
        cell.titleLabel.text = "タイトル：" + ListArray[indexPath.row][1]
        cell.kikiTypeLabel.text = "種別　　：" + kikiType
        cell.registDateLabel.text = "更新日　：" + ListArray[indexPath.row][3]
        cell.mapButton.addTarget(self, action: #selector(self.mapButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func mapButtonTapped(sender: AnyObject){
        
        let btn = sender as! UIButton
        let cell = btn.superview as! KikiListCustomViewCell
        let row = myTableView1.indexPath(for: cell)?.row
        
        self.tabBarController?.selectedIndex = 0
        let nc:UINavigationController = self.tabBarController?.viewControllers?[0] as! UINavigationController
        let vc:ViewController = nc.topViewController as! ViewController
        let LIE:LocationInfoEntity = LIEArray[row!]
        
        vc.moveCenter(latitude: LIE.latitude, longitude: LIE.longitude)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルがタップされた時の処理
        transitionKikiDetail(LIE: LIEArray[indexPath.row])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //func displayList(LIEArray:[LocationInfoEntity],documentIdList:[String]){
    func displayList(LIEArray:[LocationInfoEntity]){

        self.LIEArray = LIEArray
        let LIECount = LIEArray.count
        
        //var cnt:Int = 0
        
        for LIE in LIEArray{
            
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: LIE.latitude, longitude: LIE.longitude)
            
            geocoder.reverseGeocodeLocation(location){(placemarks,error) in
                if let placemarks = placemarks{
                    if let pm = placemarks.first {
                        //self.displayList(address: pm.administrativeArea! + pm.locality! + pm.thoroughfare!)
                        let administrativeArea:String = pm.administrativeArea ?? ""
                        let locality:String = pm.locality ?? ""
                        let thoroughfare:String = pm.thoroughfare ?? ""
                        self.ListArray.append([administrativeArea + locality + thoroughfare,LIE.title,String(LIE.kikiType),LIE.updateDate])

                        if LIECount == self.ListArray.count{
                            self.ListArray = self.ListArray.sorted(by: { (a, b) -> Bool in
                                return a[3] > b[3]
                            })
                            //ソート順をListArrayに合わせる
                            self.LIEArray = self.LIEArray.sorted(by: { (a, b) -> Bool in
                                return a.updateDate > b.updateDate
                            })

                            self.tableViewAdd()
                        }
                        //cnt = cnt + 1
                        
                    }
                }else{
                    self.ListArray.append(["住所が取得できませんでした。",LIE.title,String(LIE.kikiType),LIE.updateDate])
                    
                    //self.displayList(address: "住所が取得できませんでした。")
                    if LIECount == self.ListArray.count{
                        self.ListArray = self.ListArray.sorted(by: { (a, b) -> Bool in
                            return a[3] > b[3]
                        })
                        //ソート順をListArrayに合わせる
                        self.LIEArray = self.LIEArray.sorted(by: { (a, b) -> Bool in
                            return a.updateDate > b.updateDate
                        })

                        self.tableViewAdd()
                    }
                    //cnt = cnt + 1

                }
                
            }

        }
        
        //indicator.hideIndicator()
            

        
    }
    
    func tableViewAdd(){
        myTableView1 = UITableView(frame: self.view.frame, style: UITableView.Style.grouped)
        myTableView1.delegate = self
        myTableView1.dataSource = self
        //myTableView1.estimatedRowHeight = 100
        myTableView1.rowHeight = UITableView.automaticDimension
        
        myTableView1.register(KikiListCustomViewCell.self, forCellReuseIdentifier: NSStringFromClass(KikiListCustomViewCell.self))
        myTableView1.backgroundColor = UIColor.init(red:240/255,green:240/255,blue:240/255,alpha:1)
        
        //myTableView1.estimatedRowHeight = 150
        myTableView1.rowHeight = 100
        
        self.view.addSubview(myTableView1)

    }
    
    func displayNon() {
        let nonLabel = UILabel(frame: CGRect(x: 100, y: 100, width: 400, height: 30))
        nonLabel.text = "no data"
        nonLabel.sizeToFit()
        nonLabel.center = self.view.center
        nonLabel.textColor = UIColor.black
        nonLabel.font = UIFont.systemFont(ofSize: 24)
        self.view.addSubview(nonLabel)
    }
    
    //func transitionKikiDetail(documentId:String,LIE: LocationInfoEntity) {
    func transitionKikiDetail(LIE: LocationInfoEntity) {
        
        let KikiDetailVC = KikiDetailViewController()
        KikiDetailVC.passedLocation = LIE
        //KikiDetailVC.passedDocumentId = documentId
        
        //ViewControllerをrootに
        let nav = UINavigationController(rootViewController: KikiDetailVC)
        
        //オープン
        self.present(nav,animated:true,completion: nil)
        
    }

}
