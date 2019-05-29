//
//  KikiModel.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/11/06.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import Foundation
import Firebase

protocol KikiSearchModelInterface {
    
    init(presenter:KikiSearchPresenterInterface)
    
    //func getKiki() -> [LocationInfoEntity]
    //func getKiki(latitude:Double,longitude:Double,latitudeDelta:Double,longitudeDelta:Double) -> [LocationInfoEntity]
    func getKiki(latitude:Double,longitude:Double,latitudeDelta:Double,longitudeDelta:Double) -> Void

    //func getKiki(documentId:String) -> LocationInfoEntity
    func getKiki(documentId:String) -> Void
    
    func getKikiOrderByYmd() -> Void
    
    func markKiki(LIE:LocationInfoEntity) -> Void
    
    //func displayList(LIEArray:[LocationInfoEntity],documentIdList:[String]) -> Void

    func displayList(LIEArray:[LocationInfoEntity]) -> Void

    func displayNon() -> Void
    
    //func transitionKikiDetail(documentId:String,LIE:LocationInfoEntity) -> Void
    
    func transitionKikiDetail(LIE:LocationInfoEntity) -> Void
    
}

class KikiSearchModel: KikiSearchModelInterface{
    
    var presenter:KikiSearchPresenterInterface
    
    var db : Firestore!
    
    required init(presenter:KikiSearchPresenterInterface){
        self.presenter = presenter
        db = Firestore.firestore()
    }
    
    func getKiki(latitude:Double,longitude:Double,latitudeDelta:Double,longitudeDelta:Double) -> Void {
        
        let LIERef :CollectionReference = db.collection("LocationInfo")
        
        var LIEAllay:[LocationInfoEntity]! = []
        var filteredLIEArray:[LocationInfoEntity]! = []
        
        LIERef
            .whereField("latitude", isLessThanOrEqualTo: latitude + latitudeDelta)
            .whereField("latitude", isGreaterThanOrEqualTo: latitude - latitudeDelta)
            //LIERef
            //    .whereField("longitude", isLessThanOrEqualTo: longitude + longitudeDelta)
            //    .whereField("longitude", isGreaterThanOrEqualTo: longitude - longitudeDelta)
            
            .getDocuments { (snapshot, err) in
                if snapshot != nil{
                    for document in snapshot!.documents{
                        let data = document.data()
                        //print("\(document.documentID) => \(document.data())")
                        do{
                            let LIEJson = try JSONSerialization.data(withJSONObject: data)
                            var decodedLIE = try JSONDecoder().decode(LocationInfoEntity.self, from: LIEJson)
                            //titleにdocumentIDをセット
                            //decodedLIE.title = document.documentID
                            decodedLIE.documentId = document.documentID
                            LIEAllay.append(decodedLIE)
                        }catch{
                            print(error)
                        }
                        
                    }
                }else{
                    print("kiki nothing")
                }
                
                //print("LIEAllay_count:\(LIEAllay.count)")
                //print("LIEAllay_longitude:\(LIEAllay.first?.longitude)")
                //print("LIEAllay_latitude:\(LIEAllay.first?.latitude)")
                //print("longitude + longitudeDelta:\(longitude + longitudeDelta)")
                //print("longitude - longitudeDelta:\(longitude - longitudeDelta)")
                
                filteredLIEArray = LIEAllay
                    .filter{ $0.longitude <= (longitude + longitudeDelta) }
                    .filter{ $0.longitude >= (longitude - longitudeDelta) }
                
                for LIE in filteredLIEArray{
                    self.markKiki(LIE: LIE)
                }
                
        }
        
    }
    
    //func getKiki(documentId:String) -> LocationInfoEntity {
    func getKiki(documentId:String) -> Void {
        
        let docRef = db.collection("LocationInfo").document(documentId)
        
        var LIE:LocationInfoEntity!
        
        docRef.getDocument { (document, error) in
                if let document = document,document.exists{
                    let data = document.data()
                    //print("\(document.documentID) => \(document.data())")
                    do{
                        let LIEJson = try JSONSerialization.data(withJSONObject: data)
                        //print("LIEJson:\(LIEJson)")
                        LIE = try JSONDecoder().decode(LocationInfoEntity.self, from: LIEJson)
                        LIE.documentId = document.documentID
                        //self.transitionKikiDetail(documentId:document.documentID,LIE: LIE)
                        self.transitionKikiDetail(LIE: LIE)
                    }catch{
                        print(error)
                    }
                }else{
                    print("kiki nothing")
                }
                
        }
        
        //return LIE
        
    }
    
    func getKikiOrderByYmd() -> Void {
        
        let LIERef :CollectionReference = db.collection("LocationInfo")
        
        var LIEAllay:[LocationInfoEntity]! = []
        
        //var documentIdList:[String]! = []
        
        LIERef
            .order(by: "updateDate",descending: true)
            .limit(to: 20)
            .getDocuments { (snapshot, err) in
                if snapshot != nil{
                    for document in snapshot!.documents{
                        let data = document.data()
                        //print("\(document.documentID) => \(document.data())")
                        do{
                            let LIEJson = try JSONSerialization.data(withJSONObject: data)
                            var decodedLIE = try JSONDecoder().decode(LocationInfoEntity.self, from: LIEJson)
                            //titleにdocumentIDをセット
                            //documentIdList.append(document.documentID)
                            decodedLIE.documentId = document.documentID
                            LIEAllay.append(decodedLIE)
                        }catch{
                            print(error)
                        }
                        
                    }
                    
                    if LIEAllay.count != 0{
                        //self.displayList(LIEArray: LIEAllay,documentIdList:documentIdList)
                        self.displayList(LIEArray: LIEAllay)

                    }else{
                        self.displayNon()

                    }

                    
                }else{
                    //print("kiki nothing")
                    self.displayNon()
                }

        }
        
    }

    
    func markKiki(LIE: LocationInfoEntity) {
        self.presenter.markKiki(LIE: LIE)
    }
    
    func displayList(LIEArray:[LocationInfoEntity]){
        self.presenter.displayList(LIEArray:LIEArray)
    }

    func displayNon(){
        self.presenter.displayNon()
    }
    
    func transitionKikiDetail(LIE: LocationInfoEntity) {
        self.presenter.transitionKikiDetail(LIE: LIE)
    }

}

extension KikiSearchModelInterface{
    func bark() -> String{
        return "aaaa"
    }
}

