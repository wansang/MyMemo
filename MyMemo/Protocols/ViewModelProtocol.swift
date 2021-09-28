//
//  ViewModelProtocol.swift
//  ItBooks
//
//  Created by wsryu on 2021/09/15.
//

import RxSwift
import RxCocoa

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output

    var title: Observable<String>? { get set }
    func transform(input: Input) ->Output
}

protocol ServicesViewModelProtocol: ViewModelProtocol {
    associatedtype Services
    var services: Services! { get set }
}
