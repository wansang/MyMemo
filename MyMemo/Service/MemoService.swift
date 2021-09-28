//
//  MemoService.swift
//  MyMemo
//
//  Created by wsryu on 2021/09/27.
//

import RxSwift

struct MemoService:ServiceProtocol {
    var repository: MemoRepository!
    
    func memoList() -> Observable<[MemoModel]> {
        return repository.memoList()
    }
    
    func saveMemo(memo:String,date:Date) -> Single<Bool>{
        return repository.saveMemo(memo: memo, date:date)
    }
    
    func updateMemo(memo:String,date:Date,indentity:String) -> Single<Bool>{
        return repository.updateMemo(memo: memo, date: date, identity: indentity)
    }
    
    func deleteMemo(memo:MemoModel) -> Observable<[MemoModel]>{
        return repository.deleteMemo(memo: memo)
    }
}
