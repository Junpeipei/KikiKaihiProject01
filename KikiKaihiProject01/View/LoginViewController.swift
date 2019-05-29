//
//  LoginViewController.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/11/28.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import UIKit
import UserNotifications

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    let titleLabel = UILabel()
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet var submitButton: KikiCustomButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print("loginSet")
        
        let topColor = UIColor(red: 220/255, green: 225/255, blue: 225/255, alpha: 1)
        let bottomColor = UIColor(red: 240/255, green: 245/255, blue: 245/255, alpha: 1)
        let gradientColors:[CGColor] = [topColor.cgColor,bottomColor.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        //self.view.backgroundColor = UIColor.lightGray

        let screenWidth:CGFloat = self.view.frame.width
        let screenHeight:CGFloat = self.view.frame.height

        titleLabel.frame = CGRect(x:screenWidth / 4 ,y:screenHeight / 10 * 2,width:screenWidth/2 ,height:50)
        titleLabel.text = "ログイン"
        titleLabel.textColor = UIColor(red:60/255,green:65/255,blue:65/255,alpha:1)
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(titleLabel)

        
        //TextFieldの生成
        userNameTextField = UITextField()
        userNameTextField.frame = CGRect(x: screenWidth / 4 ,y:screenHeight / 10 * 4 - 50,width:screenWidth/2 ,height:50)
        userNameTextField.delegate = self
        userNameTextField.borderStyle = .roundedRect
        userNameTextField.clearButtonMode = .whileEditing
        userNameTextField.returnKeyType = .done
        userNameTextField.placeholder = "userName"
        self.view.addSubview(userNameTextField)
        
        userPasswordTextField = UITextField()
        userPasswordTextField.frame = CGRect(x: screenWidth / 4 ,y:screenHeight / 10 * 4 + 50,width:screenWidth/2 ,height:50)
        userPasswordTextField.delegate = self
        userPasswordTextField.borderStyle = .roundedRect
        userPasswordTextField.clearButtonMode = .whileEditing
        userPasswordTextField.returnKeyType = .done
        userPasswordTextField.isSecureTextEntry = true
        userPasswordTextField.placeholder = "userPassword"
        self.view.addSubview(userPasswordTextField)
        
        submitButton = KikiCustomButton()
        submitButton.frame = CGRect(x: screenWidth / 4 ,y:screenHeight / 10 * 8,width:screenWidth/2 ,height:50)
        submitButton.layer.cornerRadius = 10
        submitButton.setTitle("ログイン", for: UIControl.State.normal)
        submitButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        submitButton.backgroundColor = UIColor.init(red:60/255,green:65/255,blue:65/255,alpha:1)
        submitButton.addTarget(self, action: #selector(self.loginButtonTapped(_:)), for: .touchUpInside)
        //submitButton.animation = "flash"
        //submitButton.duration = 0.5
        
        self.view.addSubview(submitButton)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let userName = Int(userNameTextField.text!)
        let userPassword = Int(userPasswordTextField.text!)
        //let userNameStored = UserDefaults.standard.string(forKey: "userName")
        //let userPasswordStored = UserDefaults.standard.string(forKey: "userPassword")
        let userNameStored = 1234567
        let userPasswordStored = 1234

        //self.view.backgroundColor = UIColor(red:0.5,green:0.5,blue:0.5,alpha:0.7)
        
        if(userNameStored == userName){
            
            if(userPasswordStored == userPassword){
                
                // ログイン！
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.set(userName, forKey: "loginUser")
                //UserDefaults.standard.synchronize()
                self.dismiss(animated: true, completion:nil)
                
            }
            
        }
        
        let alert:UIAlertController = UIAlertController(title: "ログインに失敗しました。", message: "", preferredStyle: .alert)
        self.present(alert, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 , execute: {
                alert.dismiss(animated: true, completion: nil)
            })
        })
        /*
        let OKAction = UIAlertAction(title: "すいません", style: .default) { action in
            
        }
         */
        
        //alert.addAction(OKAction)
        
        //present(alert,animated: true,completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
}
