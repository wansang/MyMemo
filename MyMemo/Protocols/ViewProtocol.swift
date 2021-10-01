//
//  ViewProtocol.swift
//  ItBooks
//
//  Created by wsryu on 2021/09/15.
//

import RxSwift
import Reusable

protocol ViewProtocol:AnyObject {
    associatedtype ViewModelType: ViewModelProtocol
    var viewModel: ViewModelType! { get set }
 
    func setupCommon()
    func configurationUI()
    func bindViewModel()
    func bindInput()->ViewModelType.Input
    func bindOutput(input:ViewModelType.Input)
    func bindUI()
}

extension ViewProtocol{
    func setupCommon(){
        self.configurationUI()
        self.bindViewModel()
    }
    
    func bindViewModel(){
        self.bindOutput(input: self.bindInput())
        self.bindUI()
    }
}

extension ViewProtocol where Self: StoryboardBased & UIViewController, ViewModelType: ServicesViewModelProtocol {
    static func instantiate<ViewModelType> (withViewModel viewModel: ViewModelType) -> Self
        where ViewModelType == Self.ViewModelType{
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
}
