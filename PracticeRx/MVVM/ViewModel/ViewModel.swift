//
//  ViewModel.swift
//  PracticeRx
//
//  Created by 三浦　登哉 on 2021/06/09.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

// ViewModelへの入力
protocol ViewModelInput {
    var searchTextObserver: AnyObserver<String> { get } // 外部からの入力を受け取るときはAnyObserver
}

// ViewModelの出力
protocol ViewModelOutput {
    var changeModelObservable: Observable<Void> { get }
    var models: [GithubModel] { get }
}

final class ViewModel:  ViewModelInput, ViewModelOutput, HasDisposeBag {
    /*入力*/
    // 入力を受け取ってイベントを流す
    private let _searchText = PublishRelay<String>() // 外部からイベントを流せないように
    lazy var searchTextObserver: AnyObserver<String> = .init(eventHandler: { event in
        guard let text = event.element else { return }
        self._searchText.accept(text)
    })
    
    /*出力*/
    private let _changeModelObservable = PublishRelay<Void>() // 外部からイベントを流せないように
    lazy var changeModelObservable: Observable<Void> = _changeModelObservable.asObservable()
    // 取得データ
    private(set) var models: [GithubModel] = []
    private var error: GithubError?
    // ストリームを決める
    init() {
        _searchText
            .map{ word in
                API.shared.getRepositoly(searchWord: word) { result -> Void in
                    switch result {
                    case .success(let model):
                        self.models = model
                    case .failure(_): break
                    }
                }
                return
            }
            .bind(to: _changeModelObservable)
            .disposed(by: disposeBag)
    }
}
