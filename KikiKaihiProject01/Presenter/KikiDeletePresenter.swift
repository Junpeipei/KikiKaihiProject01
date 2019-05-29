//
//  KikiDeletePresenter.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/12/04.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import Foundation

protocol KikiDeletePresenterInterface{
    
    init(view:KikiDetailViewInterface,documentId:String ,modelType Model:KikiDeleteModelInterface.Type)
    
    //func registKiki() -> Bool
    func deleteKiki() -> Void
    
}

class KikiDeletePresenter:KikiDeletePresenterInterface{
    
    private weak var view:KikiDetailViewInterface?
    
    private var model:KikiDeleteModelInterface!
    
    required init(view: KikiDetailViewInterface, documentId: String, modelType Model: KikiDeleteModelInterface.Type) {
        self.view = view
        self.model = Model.init(presenter:self,documentId:documentId)
    }

    /*
     func registKiki() -> Bool {
     return model.registKiki()
     }
     */
    
    func deleteKiki() -> Void {
        
        self.view?.backMap(result:model.deleteKiki())
        
        /*
        if model.deleteKiki() {
            self.view?.backMap()
        }else{
            self.view?.backMap()
        }
        */
        
    }
    
}

