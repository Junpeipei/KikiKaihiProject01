//
//  KikiUpdatePresenter.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/12/04.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import Foundation

protocol KikiUpdatePresenterInterface{
    
    init(view:KikiUpdateViewInterface,LIE:LocationInfoEntity ,documentId:String ,modelType Model:KikiUpdateModelInterface.Type)
    
    //func registKiki() -> Bool
    func updateKiki() -> Void
    
}

class KikiUpdatePresenter:KikiUpdatePresenterInterface{
    
    private weak var view:KikiUpdateViewInterface?
    
    private var model:KikiUpdateModelInterface!
    
    required init(view:KikiUpdateViewInterface,LIE:LocationInfoEntity ,documentId:String,modelType Model:KikiUpdateModelInterface.Type) {
        self.view = view
        self.model = Model.init(presenter:self,LIE:LIE,documentId:documentId)
    }
    
    /*
     func registKiki() -> Bool {
     return model.registKiki()
     }
     */
    
    func updateKiki() -> Void {
        
        self.view?.backMap(result:model.updateKiki())
        
        /*
        if model.updateKiki() {
            self.view?.backMap()
        }else{
            self.view?.backMap()
        }
        */
        
    }
    
}

