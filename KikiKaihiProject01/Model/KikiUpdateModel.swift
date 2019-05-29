//
//  KikiUpdateModel.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/12/04.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import Foundation
import Firebase

protocol KikiUpdateModelInterface {
    
    init(presenter:KikiUpdatePresenterInterface,LIE:LocationInfoEntity ,documentId:String)
    
    func updateKiki() -> Bool
    //func registKiki() -> Void
    
}

class KikiUpdateModel: KikiUpdateModelInterface{
    
    var db : Firestore!
    
    var presenter:KikiUpdatePresenterInterface
    
    let LIE:LocationInfoEntity
    let documentId:String
    let jsonstr:String
    var dictionary :Dictionary<String, Any>! = ["kari":0]
    
    
    required init(presenter:KikiUpdatePresenterInterface,LIE:LocationInfoEntity ,documentId:String){
        self.presenter = presenter
        self.LIE = LIE
        self.documentId = documentId
        db = Firestore.firestore()
        
        let data = try! JSONEncoder().encode(LIE)
        jsonstr = String(data:data,encoding:.utf8)!
        print(jsonstr)
        
        do{
            self.dictionary = try (JSONSerialization.jsonObject(with: data, options: .allowFragments)as? [String:Any])
            
        } catch{
            
        }
        
        
    }
    
    func updateKiki() -> Bool {
        var result:Bool = true
        db.collection("LocationInfo").document(documentId).setData(dictionary){
            err in
            if err != nil{
                print("Error adding document: \(err)")
                result = false
            } else {
                result = true
            }
        }
        return result
    }
    
}
