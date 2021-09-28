//
//  AppStep.swift
//  BaseApp
//
//  Created by wsryu on 2021/09/08.
//

//Step은 어플리케이션의 네비게이션 상태입니다. Flow와 Step을 조합하면 가능한 모든 네비게이션 액션을 설명할 수 있습니다. Step은 내부 값(Ids, URLs 등이 있습니다)을 임베드할 수 있어서 Flow에 선언된 화면에 전달할 수도 있습니다.

import RxFlow

enum AppStep: Step {
    case main
    case memo(withMemo:MemoModel?)
}
