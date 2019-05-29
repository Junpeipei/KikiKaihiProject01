//
//  ViewController.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/11/06.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


protocol KikiViewInterface:class{
    //var LIE:LocationInfoEntity{get set}
    
    func markKiki(LIE:LocationInfoEntity) -> Void
    
    func getKiki(latitude:Double,longitude:Double) -> Void
    
    //func transitionKikiDetail(documentId:String,LIE:LocationInfoEntity) -> Void
    
    func transitionKikiDetail(LIE:LocationInfoEntity) -> Void
    
}

extension ViewController:KikiViewInterface{
    //var LIE: LocationInfoEntity = LocationInfoEntity()
    
    
}


class ViewController: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()
    
    var myMapView: MKMapView!
    
    //var kikiPresenter: KikiSearchPresenterInterface!
    
    var LIE: LocationInfoEntity!
    
    var region:MKCoordinateRegion!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        //画面背景色を設定
        self.view.backgroundColor = UIColor(red:0.7,green:0.7,blue:0.7,alpha:0.7)
                
    }
    
    //画面回転にも対応する
    override func viewDidAppear(_ animated:Bool){
        
        var topPadding: CGFloat = 0
        var bottomPadding: CGFloat = 0
        var leftPadding: CGFloat = 0
        var rightPadding: CGFloat = 0
        
        if #available(iOS 11.0, *){
            let window = UIApplication.shared.keyWindow
            topPadding = window!.safeAreaInsets.top
            bottomPadding = window!.safeAreaInsets.bottom
            leftPadding = window!.safeAreaInsets.left
            rightPadding = window!.safeAreaInsets.right
        }
        
        
        
        
        
        //let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //print(documentPath)
        
        //位置情報サービスの確認
        CLLocationManager.locationServicesEnabled()
        
        //セキュリティ認証のステータス
        let status = CLLocationManager.authorizationStatus()
        
        if(status == CLAuthorizationStatus.notDetermined){
            print("NotDetermined")
            //許可をリクエスト
            locationManager.requestWhenInUseAuthorization()
        }
        else if(status == CLAuthorizationStatus.restricted){
            print("Restricted")
        }
        else if(status == CLAuthorizationStatus.authorizedWhenInUse){
            print("authorizedWhenInUse")
        }
        else if(status == CLAuthorizationStatus.authorizedAlways){
            print("authorizedAlways")
        }
        else{
            print("not allowed")
        }
        
        //位置情報の更新
        locationManager.startUpdatingLocation()
        
        //MapViewのインスタンス生成
        myMapView = MKMapView()
        
        //MAPの表示タイプを設定
        myMapView.mapType = MKMapType.standard
        //myMapView.mapType = MKMapType.hybrid

        //MapViewをSafeAreaに収める
        //以降、Landscapeのみを想定
        let screenWidth = view.frame.size.width
        let screenHeight = view.frame.size.height
        
        let rect = CGRect(x:leftPadding,
                          y:topPadding,
                          width:screenWidth - leftPadding - rightPadding,
                          height:screenHeight - topPadding - bottomPadding)
        
        myMapView.frame = rect
        
        //Delegateを設定
        myMapView.delegate = self
        
        //縮尺を設定
        region = myMapView.region
        region.center = myMapView.userLocation.coordinate
        
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        
        myMapView.setRegion(region, animated: true)
        
        //MapViewをViewに追加
        self.view.addSubview(myMapView)
        
        
        //myMapView.userTrackingMode = MKUserTrackingMode.follow
        //myMapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        //長押しのUIGestureRecognizerを生成
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(ViewController.recognizeLongPress(sender:)))
        
        //MapViewにUIGestureRecognizerを追加
        myMapView.addGestureRecognizer(myLongPress)
        
        //getKiki(latitude:(manager.location?.coordinate.latitude)!,longitude:(manager.location?.coordinate.longitude)!)

        if myMapView.centerCoordinate.latitude != 0.0 && myMapView.centerCoordinate.longitude != 0.0{
            getKiki(latitude:myMapView.centerCoordinate.latitude,longitude:myMapView.centerCoordinate.longitude)
        }
        
        //現在地移動ボタンの作成
        let genzaichiButton = KikiCustomButton()
        
        genzaichiButton.frame = CGRect(x: self.view.frame.width - 75, y: self.view.frame.height - 125, width: 50, height: 50)
        genzaichiButton.layer.cornerRadius = 25
        genzaichiButton.backgroundColor = UIColor.init(red:1,green:1,blue:1,alpha:1)
        genzaichiButton.addTarget(self, action: #selector(ViewController.genzaichiButtonTapped(sender:)), for: .touchUpInside)
        
        let BIV1 = UIImageView(frame: genzaichiButton.bounds)
        BIV1.clipsToBounds = true
        BIV1.layer.cornerRadius = 25
        BIV1.image = UIImage(named: "genzaichi.jpg")!
        genzaichiButton.addSubview(BIV1)
        
        //現在地で登録ボタンの作成
        let registButton = KikiCustomButton()
        
        registButton.frame = CGRect(x: self.view.frame.width - 75, y: self.view.frame.height - 200, width: 50, height: 50)
        registButton.layer.cornerRadius = 25
        registButton.backgroundColor = UIColor.init(red:1,green:1,blue:1,alpha:1)
        registButton.addTarget(self, action: #selector(ViewController.registButtonTapped(sender:)), for: .touchUpInside)
        
        let BIV2 = UIImageView(frame: registButton.bounds)
        BIV2.clipsToBounds = true
        BIV2.layer.cornerRadius = 25
        BIV2.image = UIImage(named: "pencil.jpg")!.resize(width: 30, height: 30)
        registButton.addSubview(BIV2)
        
        
        self.view.addSubview(genzaichiButton)
        self.view.addSubview(registButton)

    }
    
    //現在地移動ボタン
    @objc func genzaichiButtonTapped(sender:AnyObject){
        myMapView.setCenter((locationManager.location?.coordinate)!, animated: true)
        dispPositionLat = (locationManager.location?.coordinate.latitude)!
        dispPositionLon = (locationManager.location?.coordinate.longitude)!
    }
    
    //現在地で登録ボタン
    @objc func registButtonTapped(sender:AnyObject){
        
        let _pushLocation = LocationInfoEntity(documentId:"",latitude: (locationManager.location?.coordinate)!.latitude,longitude: (locationManager.location?.coordinate)!.longitude,title:"",content:"",kikiType:0,registUser:1234567,registDate:"9999/12/31 99:99:99",updateDate:"9999/12/31 99:99:99")
        
        //次のViewControllerのインスタンスを作成
        let modalVC = ModalViewController()
        //modalVC.passedString = "test"
        modalVC.passedLocation = _pushLocation
        
        //ViewControllerをrootに
        let nav = UINavigationController(rootViewController: modalVC)
        
        //オープン
        self.present(nav,animated:true,completion: nil)
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("myMapView:\(myMapView)")
        //let center = myMapView.centerCoordinate
        //getKiki(latitude:center.latitude,longitude:center.longitude)
        if firstLM{
            //print("dispLat\(dispPositionLat)")
            //print("dispLon\(dispPositionLon)")
            self.moveCenter(latitude: dispPositionLat, longitude: dispPositionLon)
            getKiki(latitude: dispPositionLat, longitude: dispPositionLon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*
        kikiPresenter = KikiSearchPresenter(latitude:(manager.location?.coordinate.latitude)!,longitude:(manager.location?.coordinate.longitude)!, modelType: KikiSearchModel.self)
        let LIEAllay:[LocationInfoEntity] = kikiPresenter.getKiki()
        */
 
        if !firstLM{
            firstLM = true
            //myMapView.setCenter((manager.location?.coordinate)!, animated: true)
            self.moveCenter(latitude: (manager.location?.coordinate.latitude)!, longitude: (manager.location?.coordinate.longitude)!)
            dispPositionLat = (manager.location?.coordinate.latitude)!
            dispPositionLon = (manager.location?.coordinate.longitude)!
            
            getKiki(latitude:(manager.location?.coordinate.latitude)!,longitude:(manager.location?.coordinate.longitude)!)
        }
        
        


    }
    
    func mapView(_ mapView: MKMapView,regionDidChangeAnimated animated: Bool){
        //print("region changed")
        if mapView.centerCoordinate.latitude != 0 && mapView.centerCoordinate.longitude != 0{
            getKiki(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            dispPositionLat = mapView.centerCoordinate.latitude
            dispPositionLon = mapView.centerCoordinate.longitude
        }
    }
    
    func getKiki(latitude:Double,longitude:Double){
        
        if region != nil {
            let kikiPresenter:KikiSearchPresenterInterface = KikiSearchPresenter(view:self,modelType: KikiSearchModel.self)
            kikiPresenter.getKiki(latitude: latitude, longitude: longitude, latitudeDelta:region.span.latitudeDelta, longitudeDelta: region.span.longitudeDelta)

        }

        
    }
    
    func markKiki(LIE: LocationInfoEntity) {
        
        
        //ピンを生成
        let myPin:MKPointAnnotation = MKPointAnnotation()
        
        //座標を設定
        myPin.coordinate.latitude = LIE.latitude
        myPin.coordinate.longitude = LIE.longitude

        //タイトルを設定
        //myPin.title = LIE.title
        myPin.title = LIE.documentId
        
        //サブタイトルを設定
        myPin.subtitle = String(LIE.kikiType)
        
        //myPin.setValue(LIE.kikiType, forKey: "kikiType")
        
        //MapViewにピンを追加
        myMapView.addAnnotation(myPin)
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let myIdenfifier = "myPin"
        
        var myAnnotation: MKAnnotationView!
        
        if myAnnotation == nil {
            myAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: myIdenfifier)
        }
        
        switch annotation.subtitle {
        case "0":
            myAnnotation.image = UIImage(named: "0_animal.png")?.resize(width: 50, height: 50)
            myAnnotation.annotation = annotation
        case "1":
            myAnnotation.image = UIImage(named: "1_obstacle.jpg")?.resize(width: 40, height: 40)
            myAnnotation.annotation = annotation
        case "2":
            myAnnotation.image = UIImage(named: "2_accident.png")?.resize(width: 40, height: 40)
            myAnnotation.annotation = annotation
        case "3":
            myAnnotation.image = UIImage(named: "3_disaster.png")?.resize(width: 50, height: 50)
            myAnnotation.annotation = annotation
        case "4":
            myAnnotation.image = UIImage(named: "4_hatena.png")?.resize(width: 40, height: 40)
            myAnnotation.annotation = annotation
        default:
            print("annotation Error")
        }
                
        
        return myAnnotation
        
    }
    
    //annotationがタップされた時の処理
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation
        let title = annotation?.title
        let kikiPresenter:KikiSearchPresenterInterface = KikiSearchPresenter(view:self,modelType: KikiSearchModel.self)
        //let LIE:LocationInfoEntity = kikiPresenter.getKiki(documentId: title!!)
        kikiPresenter.getKiki(documentId: title!!)
        
        
        
        //print(title)
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
 
    
    //長押しを感知した時に呼ばれるメソッド
    @objc func recognizeLongPress(sender: UILongPressGestureRecognizer){
        
        //長押しの最中に何度もピンを発生しないようにする
        if sender.state != UIGestureRecognizer.State.began{
            return
        }
        
        //長押しした地点の座標を取得
        let location = sender.location(in:myMapView)
        
        //locationをCLLocationCoodinate2Dに変換
        let myCoodinate: CLLocationCoordinate2D = myMapView.convert(location, toCoordinateFrom: myMapView)
        
        let _pushLocation = LocationInfoEntity(documentId:"",latitude: myCoodinate.latitude,longitude: myCoodinate.longitude,title:"",content:"",kikiType:0,registUser:1234567,registDate:"9999/12/31 99:99:99",updateDate:"9999/12/31 99:99:99")
        
        //次のViewControllerのインスタンスを作成
        let modalVC = ModalViewController()
        //modalVC.passedString = "test"
        modalVC.passedLocation = _pushLocation
        
        //ViewControllerをrootに
        let nav = UINavigationController(rootViewController: modalVC)
        
        //オープン
        self.present(nav,animated:true,completion: nil)
        
    }
    
    func moveCenter(latitude:Double,longitude:Double){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            self.myMapView.setCenter(location, animated: false)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources thot can be recreated
    }
    
    
}

