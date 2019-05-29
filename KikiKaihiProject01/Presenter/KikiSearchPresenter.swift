//
//  KikiListViewPresenter.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/11/06.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import Foundation

protocol KikiSearchPresenterInterface{
    
    //init(latitude:Double,longitude:Double,modelType Model:KikiSearchModelInterface.Type)
    init(view:KikiViewInterface,modelType Model:KikiSearchModelInterface.Type)
    init(view:TimelineViewInterface,modelType Model:KikiSearchModelInterface.Type)

    var kiki:String {get}
    
    //func getKiki() -> [LocationInfoEntity]
    //func getKiki(latitude:Double,longitude:Double,latitudeDelta:Double,longitudeDelta:Double) -> [LocationInfoEntity]
    func getKiki(latitude:Double,longitude:Double,latitudeDelta:Double,longitudeDelta:Double) -> Void

    //func getKiki(documentId: String) -> LocationInfoEntity
    func getKiki(documentId: String) -> Void
    
    func getKikiOrderByYmd() -> Void

    func markKiki(LIE:LocationInfoEntity) -> Void
    
    func displayList(LIEArray:[LocationInfoEntity]) -> Void

    //func displayList(LIEArray:[LocationInfoEntity],documentIdList:[String]) -> Void

    func displayNon() -> Void
    
    //func transitionKikiDetail(documentId:String, LIE:LocationInfoEntity) -> Void
    
    func transitionKikiDetail(LIE:LocationInfoEntity) -> Void
    
}

class KikiSearchPresenter:KikiSearchPresenterInterface{
    
    private weak var view1:KikiViewInterface?

    private weak var view2:TimelineViewInterface?

    private var model:KikiSearchModelInterface!
    
    var kiki: String{
        return "aaa"
    }
    
    /*
    required init(latitude:Double,longitude:Double ,modelType Model:KikiSearchModelInterface.Type) {
        self.model = Model.init(latitude: latitude, longitude: longitude)
        print("presenter init")
    }
    
    func getKiki() -> [LocationInfoEntity] {
        return model.getKiki()
    }
    */
    
    required init(view:KikiViewInterface,modelType Model:KikiSearchModelInterface.Type) {
        self.view1 = view
        self.model = Model.init(presenter:self)
    }
    
    required init(view:TimelineViewInterface,modelType Model:KikiSearchModelInterface.Type) {
        self.view2 = view
        self.model = Model.init(presenter:self)
    }
    
    /*
    func getKiki(latitude:Double,longitude:Double,latitudeDelta:Double,longitudeDelta:Double) -> [LocationInfoEntity] {
        return model.getKiki(latitude:latitude,longitude:longitude,latitudeDelta:latitudeDelta,longitudeDelta:longitudeDelta)
    }
    */

    func getKiki(latitude:Double,longitude:Double,latitudeDelta:Double,longitudeDelta:Double) -> Void {
        model.getKiki(latitude:latitude,longitude:longitude,latitudeDelta:latitudeDelta,longitudeDelta:longitudeDelta)
    }
    
    /*
    func getKiki(documentId:String) -> LocationInfoEntity {
        return model.getKiki(documentId:documentId)
    }
    */
    
    func getKiki(documentId:String) -> Void {
        model.getKiki(documentId:documentId)
    }
    
    func getKikiOrderByYmd() -> Void{
        model.getKikiOrderByYmd()
    }
    
    func markKiki(LIE: LocationInfoEntity) {
        self.view1?.markKiki(LIE: LIE)
    }
    
    /*
    func displayList(LIEArray:[LocationInfoEntity],documentIdList:[String]){
        self.view2?.displayList(LIEArray:LIEArray,documentIdList:documentIdList)
    }
    */

    func displayList(LIEArray:[LocationInfoEntity]){
        self.view2?.displayList(LIEArray:LIEArray)
    }

    func displayNon(){
        self.view2?.displayNon()
    }
    /*
    func transitionKikiDetail(documentId:String,LIE: LocationInfoEntity) {
        self.view1?.transitionKikiDetail(documentId:documentId,LIE: LIE)
    }
    */
    
    func transitionKikiDetail(LIE: LocationInfoEntity) {
        self.view1?.transitionKikiDetail(LIE: LIE)
    }
    
}
