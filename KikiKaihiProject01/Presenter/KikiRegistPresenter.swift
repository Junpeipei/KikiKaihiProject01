//
//  KikiRegistPresenter.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/11/14.
//  Copyright © 2018年 iNET TG. All rights reserved.
//

import Foundation

protocol KikiRegistPresenterInterface{
    
    init(view:ModalViewInterface,LIE:LocationInfoEntity ,modelType Model:KikiRegistModelInterface.Type)
    
    //func registKiki() -> Bool
    func registKiki() -> Void

}

class KikiRegistPresenter:KikiRegistPresenterInterface{
    
    private weak var view:ModalViewInterface?
    
    private var model:KikiRegistModelInterface!
    
    required init(view:ModalViewInterface,LIE:LocationInfoEntity ,modelType Model:KikiRegistModelInterface.Type) {
        self.view = view
        self.model = Model.init(presenter:self,LIE:LIE)
    }
    
    /*
    func registKiki() -> Bool {
        return model.registKiki()
    }
    */

    func registKiki() -> Void {
        if model.registKiki() {
            self.view?.backMap()
        }else{
            self.view?.backMap()
        }
        
    }

}

