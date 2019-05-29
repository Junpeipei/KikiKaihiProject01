//
//  KikiRegistModel.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/11/14.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import Foundation
import Firebase

protocol KikiRegistModelInterface {
    
    init(presenter:KikiRegistPresenterInterface,LIE:LocationInfoEntity )
    
    func registKiki() -> Bool
    //func registKiki() -> Void

}

class KikiRegistModel: KikiRegistModelInterface{
    
    var db : Firestore!
    
    var presenter:KikiRegistPresenterInterface
    
    let LIE:LocationInfoEntity
    let jsonstr:String
    var dictionary :Dictionary<String, Any>! = ["kari":0]
    
    
    required init(presenter:KikiRegistPresenterInterface,LIE:LocationInfoEntity ){
        self.presenter = presenter
        self.LIE = LIE
        db = Firestore.firestore()
        
        let data = try! JSONEncoder().encode(LIE)
        jsonstr = String(data:data,encoding:.utf8)!
        //print(jsonstr)
        
        do{
            self.dictionary = try (JSONSerialization.jsonObject(with: data, options: .allowFragments)as? [String:Any])

        } catch{
            
        }
        
        
    }

    func registKiki() -> Bool {
        var result:Bool = true
        var ref:DocumentReference?
        ref = db.collection("LocationInfo").addDocument(data: dictionary){
            err in
            if err != nil{
                print("Error adding document: \(err)")
                result = false
            } else {
                //print("Document added with ID: \(ref!.documentID)")
                result = true
            }
        }
        return result
    }
    
}
