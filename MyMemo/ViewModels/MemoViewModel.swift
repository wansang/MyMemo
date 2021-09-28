//
//  MemoViewModel.swift
//  MyMemo
//
//  Created by wsryu on 2021/09/27.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow
import Action

struct MemoViewModel:ServicesViewModelProtocol,Stepper{
    var title: Observable<String>?
    var services: MemoService!
    var memo:MemoModel?
    let steps: PublishRelay<Step> = PublishRelay<Step>()
    
    struct Input {
        let saveMemo:Observable<String>
    }
    
    struct Output {
        let editMemo:Driver<String>?
        let saveDone:Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        var editMemo:Driver<String>?
        
        if let data = self.memo{
            editMemo = Driver.just(data.content)
        }
        
        let saveDone = input.saveMemo.flatMapLatest { value -> Single<Bool>  in
            if let data = self.memo{
                return self.services.updateMemo(memo: value, date: Date(), indentity: data.identity)
            }else{
                return self.services.saveMemo(memo: value, date: Date())
            }
        }.asDriver(onErrorJustReturn: false)
        
        return Output(editMemo: editMemo, saveDone: saveDone)
    }
}
