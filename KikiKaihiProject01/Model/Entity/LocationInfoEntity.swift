//
//  Location.swift
//  KikiKaihiProject01
//
//  Created by iNET TG on 2018/10/31.
//  Copyright © 2018年 iNET TG. All rights reserved.
//


struct LocationInfoEntity: Codable{
    //ドキュメントID
    var documentId:String
    //緯度
    let latitude:Double
    //経度
    let longitude:Double
    //危機タイトル
    let title:String
    //危機の内容
    var content:String
    //危機の区分
    let kikiType:Int
    //登録者
    let registUser:Int
    //登録日付
    let registDate:String
    //更新日付
    let updateDate:String
    
    init(
        documentId:String,
        latitude:Double,
        longitude:Double,
        title:String,
        content:String,
        kikiType:Int,
        registUser:Int,
        registDate:String,
        updateDate:String
    ){
        self.documentId = documentId
        self.latitude = latitude
        self.longitude = longitude
        self.title = title
        self.content = content
        self.kikiType = kikiType
        self.registUser = registUser
        self.registDate = registDate
        self.updateDate = updateDate
    }
    
}
