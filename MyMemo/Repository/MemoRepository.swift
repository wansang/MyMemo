//
//  MemoRepository.swift
//  MyMemo
//
//  Created by wsryu on 2021/09/27.
//

import Foundation
import RxSwift
import RealmSwift

struct MemoRepository {
    static private var realm:Realm = try! Realm()
    
    func memoList() -> Observable<[MemoModel]> {
        let memoList = Array(MemoRepository.realm.objects(MemoModel.self))
        
        return Observable.of(memoList)
    }
    
    func saveMemo(memo:String,date:Date) -> Single<Bool> {
        Single<Bool>.create { obs in
            let memoData = MemoModel()
            memoData.content = memo
            memoData.insertDate = date
            memoData.identity = "\(date.timeIntervalSinceReferenceDate)"
            
            try! MemoRepository.realm.write({
                MemoRepository.realm.add(memoData)
                obs(.success(true))
            })
            
            return Disposables.create()
        }
    }
    
    func updateMemo(memo:String,date:Date,identity:String) -> Single<Bool> {
        Single<Bool>.create { obs in
            let models = MemoRepository.realm.objects(MemoModel.self).filter("identity = %@", identity)

            if let model = models.first {
                try! MemoRepository.realm.write {
                    model.content = memo
                    model.insertDate = date
                    obs(.success(true))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func deleteMemo(memo:MemoModel) -> Observable<[MemoModel]>{
        try! MemoRepository.realm.write({
            MemoRepository.realm.delete(memo)
        })
        
        let memoList = Array(MemoRepository.realm.objects(MemoModel.self))
        
        return Observable.of(memoList)
    }
}
