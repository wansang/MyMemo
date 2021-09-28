//
//  MemoModel.swift
//  MyMemo
//
//  Created by wsryu on 2021/09/27.
//

import Foundation
import RealmSwift

//저장할 모델 정의
class MemoModel: Object{
    @objc dynamic var content:String = ""
    @objc dynamic var insertDate:Date = Date()
    @objc dynamic var identity:String = ""
    
    override static func primaryKey() -> String? {
        return "identity"
    }
}
