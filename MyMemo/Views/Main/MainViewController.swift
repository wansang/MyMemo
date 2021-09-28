//
//  MainViewController.swift
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

class MainViewController: UIViewController, ViewProtocol {
    typealias ViewModelType = MainViewModel
    
    var viewModel: MainViewModel!
    let refresh = PublishRelay<Bool>()
    let deleteItem = PublishRelay<MemoModel>()
    
    @IBOutlet weak var tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupCommon()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refresh.accept(true)
    }
    
    func configurationUI() {
        var rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        rightItem.rx.action = self.viewModel.newMemoAction()
        let leftItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editMode))
        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    func bindInput() -> MainViewModel.Input {
        return MainViewModel.Input(refreshMemo: self.refresh.asObservable(), deleteMemo: self.deleteItem.asObservable())
    }
    
    func bindOutput(input: MainViewModel.Input) {
        let output = self.viewModel.transform(input: input)
        
        output.memoList.drive(self.tableView.rx.items){ tableView, row, value in
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell")
            
            cell?.textLabel?.text = value.content
            
            return cell!
            
        }.disposed(by: self.rx.disposeBag)
        
        output.memoList.drive(onNext:{ [weak self] value in
            if value.isEmpty{
                let leftItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(self?.editMode))
                self?.navigationItem.leftBarButtonItem = leftItem
                self?.navigationItem.leftBarButtonItem?.isEnabled = false
            }else{
                self?.navigationItem.leftBarButtonItem?.isEnabled = true
            }
            
            self?.tableView.isEditing = false
        }).disposed(by: self.rx.disposeBag)
    }
    
    func bindUI() {
        self.viewModel.title?.bind(to: self.rx.title).disposed(by: self.rx.disposeBag)
        
        self.tableView.rx.modelSelected(MemoModel.self).subscribe(onNext:{ [weak self] model in
            self?.viewModel.memoSelectAction(model: model)
        }).disposed(by: self.rx.disposeBag)
        
        self.tableView.rx.modelDeleted(MemoModel.self).subscribe(onNext:{ [weak self] model in
            self?.deleteItem.accept(model)
        }).disposed(by: self.rx.disposeBag)
    }
    
    @objc func editMode(){
        self.tableView.isEditing = true
        let leftItem = UIBarButtonItem(title: "편집완료", style: .plain, target: self, action: #selector(editModeDone))
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc func editModeDone(){
        self.tableView.isEditing = false
        let leftItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editMode))
        self.navigationItem.leftBarButtonItem = leftItem
    }
}
