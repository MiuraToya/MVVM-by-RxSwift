//
//  ViewController.swift
//  PracticeRx
//
//  Created by 三浦　登哉 on 2021/06/09.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import NSObject_Rx

final class ViewController: UIViewController, HasDisposeBag {
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel = ViewModel()
    
    private lazy var input: ViewModelInput = viewModel
    private lazy var output: ViewModelOutput = viewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        let nib = UINib(nibName: "GithubTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        bindInputStream()
        bindOutputStream()
    }
    
    // viewModelに入力する
    func bindInputStream() {
        // 検索文字のストリームを決める
        let searchTextObservable = self.searchTextField.rx.text
            .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filterNil()
            .filter{ $0.isNotEmpty }
        
        // searchTextObserverにイベントを流す
        searchTextObservable
            .bind(to: input.searchTextObserver) // bindメソッドはストリームに値を流してくれる　例：bind(label.rx.text)
            .disposed(by: disposeBag)
    }
    
    // viewModelからの出力を受け付ける
    func bindOutputStream() {
        // viewModel内のmodelのの変化を受ける時のストリームを決める
        self.output.changeModelObservable
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? GithubTableViewCell else { return UITableViewCell()}
        let model = output.models[indexPath.item]
        cell.configure(model: model)
        return cell
    }
}
