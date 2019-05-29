//
//  ModalViewController.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/11/06.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import UIKit
import CoreLocation

protocol ModalViewInterface:class{
    //var LIE:LocationInfoEntity{get set}
    
    func backMap() -> Void
    
}

extension ModalViewController:ModalViewInterface{
    //var LIE: LocationInfoEntity = LocationInfoEntity()
    
}

class ModalViewController:UIViewController, UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    let addressLabel = UILabel()
    @IBOutlet var textTitle: UITextField!
    @IBOutlet var textSub: UITextField!
    @IBOutlet var submitButton: KikiCustomButton!
    var kikiType:Int = 0
    var registUser:Int = UserDefaults.standard.integer(forKey: "loginUser")
    var registDate:String!
    var updateDate:String!
    
    var kikiPresenter:KikiRegistPresenterInterface!
    
    //var passedString: String!
    var passedLocation: LocationInfoEntity!
    
    let dataList = ["動物","障害物","事件・事故","天災","その他"]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        // navigationタイトルを設定
        self.navigationItem.title = "危機の登録"
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: passedLocation.latitude, longitude: passedLocation.longitude)
        
        geocoder.reverseGeocodeLocation(location){(placemarks,error) in
            if let placemarks = placemarks{
                if let pm = placemarks.first {
                    //self.displayList(address: pm.administrativeArea! + pm.locality! + pm.thoroughfare!)
                    let administrativeArea:String = pm.administrativeArea ?? ""
                    let locality:String = pm.locality ?? ""
                    let thoroughfare:String = pm.thoroughfare ?? ""
                    self.addressLabelDisp(address: administrativeArea + locality + thoroughfare + "に危機情報を登録します")
                }
            }else{
                self.addressLabelDisp(address: "不明な住所です")
            }
        }
        
        
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

        let screenWidth:CGFloat = self.view.frame.width
        let screenHeight:CGFloat = self.view.frame.height

        let picker = UIPickerView(frame: CGRect(x:screenWidth / 6,y:screenHeight / 10 * 4 + 160,width:screenWidth/3 * 2,height:100))
        //picker.center = self.view.center
        
        
        
        //左上の閉じるボタン
        let closeBtn = UIBarButtonItem(
            title:"閉じる",
            style: .plain,
            target: self,
            action: #selector(self.cancelRegist(sender:))
        )
        
        self.navigationItem.setLeftBarButton(closeBtn, animated: true)
        
        //TextFieldの生成
        textTitle = UITextField()
        textTitle.frame = CGRect(x: screenWidth / 6 ,y:screenHeight / 10 * 4 - 50,width:screenWidth/3 * 2 ,height:50)
        textTitle.delegate = self
        textTitle.borderStyle = .roundedRect
        textTitle.clearButtonMode = .whileEditing
        textTitle.returnKeyType = .done
        textTitle.placeholder = "題名"
        self.view.addSubview(textTitle)
        
        textSub = UITextField()
        textSub.frame = CGRect(x: screenWidth / 6 ,y:screenHeight / 10 * 4 + 50,width:screenWidth/3 * 2 ,height:100)
        textSub.delegate = self
        textSub.borderStyle = .roundedRect
        textSub.clearButtonMode = .whileEditing
        textSub.returnKeyType = .done
        textSub.placeholder = "詳細内容"
        self.view.addSubview(textSub)
        
        //ボタンのインスタンスを作成
        //let submitButton = UIButton()
        submitButton = KikiCustomButton()
        submitButton.frame = CGRect(x: screenWidth / 6 ,y:screenHeight / 10 * 8,width:screenWidth/3 * 2 ,height:50)
        submitButton.layer.cornerRadius = 10
        submitButton.setTitle("登録", for: UIControl.State.normal)
        submitButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        submitButton.backgroundColor = UIColor.init(red:60/255,green:65/255,blue:65/255,alpha:1)
        submitButton.addTarget(self, action: #selector(ModalViewController.buttonTapped(sender:)), for: .touchUpInside)
        //submitButton.animation = "flash"
        //submitButton.duration = 0.5
        
        self.view.addSubview(submitButton)
        
        //ピッカーの作成
        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(0, inComponent: 0, animated: true)
        self.view.addSubview(picker)
        
        
        
    }
    
    @objc func cancelRegist(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    func addressLabelDisp(address:String){
        let screenWidth:CGFloat = self.view.frame.width
        let screenHeight:CGFloat = self.view.frame.height
        
        addressLabel.frame = CGRect(x:screenWidth / 6 ,y:screenHeight / 10 * 2,width:screenWidth/3 * 2 ,height:50)
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.text = address
        addressLabel.font = UIFont.systemFont(ofSize: 20)
        addressLabel.textColor = UIColor(red:60/255,green:65/255,blue:65/255,alpha:1)
        addressLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(addressLabel)
    }
    
    //完了を押すとkeyboardを閉じる処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //keyboard以外の画面を押すと閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.textTitle.isFirstResponder){
            self.textTitle.resignFirstResponder()
        }
        if(self.textSub.isFirstResponder){
            self.textSub.resignFirstResponder()
        }
    }
    
    //UITextFieldの編集前に処理を行う
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //nanika
    }
    
    //UITextFieldの編集後に処理を行う
    func textFieldDidEndEditing(_ textField: UITextField) {
        //nanika
    }
    
    @objc func buttonTapped(sender : AnyObject){
        
        let alert:UIAlertController = UIAlertController(title: "危機を登録します", message: "", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "はい", style: .default) { action in
            //現在時刻の取得
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let nowString = formatter.string(from: now)
            
            
            //self.submitButton.animate()
            let LIE = LocationInfoEntity(documentId:self.passedLocation.documentId,latitude: self.passedLocation.latitude, longitude: self.passedLocation.longitude, title: self.textTitle.text ?? "", content: self.textSub.text ?? "", kikiType: self.kikiType,registUser:self.registUser,registDate:nowString,updateDate:nowString)
            
            self.kikiPresenter = KikiRegistPresenter(view:self,LIE:LIE ,modelType: KikiRegistModel.self)
            self.kikiPresenter.registKiki()
            
        }
        
        let NGAction = UIAlertAction(title: "いいえ", style: .default) { action in
            print("nothing")
        }
        
        alert.addAction(OKAction)
        alert.addAction(NGAction)
        
        present(alert,animated: true,completion: nil)
        
        
    }
    
    //ピッカー選択時の処理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.kikiType = row
    }
    
    //表示する列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //アイテム個数を返す
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }

    //表示する文字列を返す
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList[row]
    }
    
    func backMap() -> Void{
        self.dismiss(animated: true, completion: nil)
    }
    
}
