//
//  MemoViewController.swift
//  MyMemo
//
//  Created by wsryu on 2021/09/27.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxFlow
import NSObject_Rx

class MemoViewController: UIViewController, ViewProtocol {
    typealias ViewModelType = MemoViewModel
    
    var viewModel: MemoViewModel!
    let saveMemo = PublishRelay<String>()
    
    @IBOutlet weak var textView:UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupCommon()
    }

    func configurationUI() {
        let rightItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = rightItem
        self.textView.becomeFirstResponder()
    }
    
    func bindInput() -> MemoViewModel.Input {
        return MemoViewModel.Input(saveMemo: self.saveMemo.asObservable())
    }
    
    func bindOutput(input: MemoViewModel.Input) {
        let output = self.viewModel.transform(input: input)
        
        output.saveDone.drive(onNext:{[weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: self.rx.disposeBag)
        
        output.editMemo?.drive(self.textView.rx.text).disposed(by: self.rx.disposeBag)
    }
    
    func bindUI() {
        self.viewModel.title?.bind(to: self.rx.title).disposed(by: self.rx.disposeBag)
        
//        self.textView.rx.didEndEditing.subscribe(onNext:{[weak self] in
//            if let text = self?.textView.text , text.isEmpty == false{
//                self?.saveMemo.accept(text)
//            }
//        }).disposed(by: self.rx.disposeBag)
        
        self.navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext:{[weak self] in
            if let text = self?.textView.text , text.isEmpty == false {
                self?.saveMemo.accept(text)
            }
        }).disposed(by: self.rx.disposeBag)
        
        self.textView.rx.text.subscribe(onNext:{[weak self] value in
            if let text = value{
                if text.isEmpty{
                    self?.navigationItem.rightBarButtonItem?.isEnabled = false
                }else{
                    self?.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
        }).disposed(by: self.rx.disposeBag)
    }
}
