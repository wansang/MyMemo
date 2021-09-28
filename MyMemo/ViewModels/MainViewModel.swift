//
//  MainViewModel.swift
//  MyMemo
//
//  Created by wsryu on 2021/09/27.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow
import Action

struct MainViewModel:ServicesViewModelProtocol,Stepper{
    var title: Observable<String>?
    var services: MemoService!
    let steps: PublishRelay<Step> = PublishRelay<Step>()
    
    struct Input {
        let refreshMemo:Observable<Bool>
        let deleteMemo:Observable<MemoModel>
    }
    
    struct Output {
        let memoList:Driver<[MemoModel]>
    }
    
    func transform(input: Input) -> Output {
        let refreshMemo = input.refreshMemo.flatMapLatest { _ in
            self.services.memoList()
        }.asDriver(onErrorJustReturn: [])
        
        let deleteMemo = input.deleteMemo.flatMapLatest { model in
            self.services.deleteMemo(memo: model).asDriver(onErrorJustReturn: [])
        }.asDriver(onErrorJustReturn: [])
        
        return Output(memoList: Driver.merge(refreshMemo,deleteMemo))
    }
    
    func newMemoAction()-> CocoaAction{
        return Action{ input in
            self.steps.accept(AppStep.memo(withMemo: nil))
            return Observable.empty()
        }
    }
    
    func memoSelectAction(model:MemoModel){
        self.steps.accept(AppStep.memo(withMemo: model))
    }
}
