//
//  AppFlow.swift
//  BaseApp
//
//  Created by wsryu on 2021/09/08.
//

//Flow: Flow는 어플리케이션의 네비게이션 공간을 규정합니다. 이 공간에서는 우리가 네비게이션 액션들을 선언할 수 있습니다. (UIViewController 또는 다른 Flow를 띄우는 것처럼요)

import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift

// Flow는 AnyObject를 준수하므로 class로 선언해주어야 한다.
class AppFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.navigationBar.prefersLargeTitles = true
        return viewController
    }()


    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
        case .main:
            return navigationToMain()
        case .memo(withMemo: let memo):
            return navigationToMemo(withMemo: memo)
        }
    }

    private func navigationToMain() -> FlowContributors {
        let viewModel = MainViewModel(title: Observable.just("메모리스트"), services: MemoService(repository: MemoRepository()))
        let mainViewController = MainViewController.instantiate(withViewModel: viewModel)
        self.rootViewController.pushViewController(mainViewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: mainViewController, withNextStepper: viewModel))
    }

    private func navigationToMemo(withMemo:MemoModel?) -> FlowContributors {
        var title = "메모추가"
        
        if let _ = withMemo{
            title = "메모수정"
        }
        let viewModel = MemoViewModel(title: Observable.just(title), services: MemoService(repository: MemoRepository()), memo: withMemo)
        let viewController = MemoViewController.instantiate(withViewModel: viewModel)

        self.rootViewController.pushViewController(viewController, animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: viewModel))
    }
}

class AppStepper: Stepper {
    let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()


    var initialStep: Step {
        return AppStep.main
    }
}
