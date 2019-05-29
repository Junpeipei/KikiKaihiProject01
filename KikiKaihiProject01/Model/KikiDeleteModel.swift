//
//  KikiDeleteModel.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/12/04.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import Foundation
import Firebase

protocol KikiDeleteModelInterface {
    
    init(presenter:KikiDeletePresenterInterface,documentId:String )
    
    func deleteKiki() -> Bool
    //func registKiki() -> Void
    
}

class KikiDeleteModel: KikiDeleteModelInterface{
    
    var db : Firestore!
    
    var presenter:KikiDeletePresenterInterface
    
    let documentId:String
    var dictionary :Dictionary<String, Any>! = ["kari":0]
    
    
    required init(presenter:KikiDeletePresenterInterface,documentId:String ){
        self.presenter = presenter
        self.documentId = documentId
        db = Firestore.firestore()
        
    }
    
    func deleteKiki() -> Bool {
        var result:Bool = true
        db.collection("LocationInfo").document(documentId).delete(){
            err in
            if err != nil{
                print("Error adding document: \(err)")
                result = false
            } else {
                print("delete success!")
                result = true
            }
        }
        return result
    }
    
}
