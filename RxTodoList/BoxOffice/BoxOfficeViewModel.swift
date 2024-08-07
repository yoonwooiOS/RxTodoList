//
//  BoxOfficeViewModel.swift
//  RxTodoList
//
//  Created by 김윤우 on 8/7/24.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOfficeViewModel {
    private let disposeBag = DisposeBag()
    private let movieList =  Observable.just(["축구", "양궁", "수영", "탁구","서핑", "클라이밍"])
    private var recentList: [String] = []
    
    struct Input {
        let recentText: PublishSubject<String>
        let searchBarText: ControlProperty<String>
        let searchButtonTap: ControlEvent<Void>
        let tableViewEvent: Observable<(ControlEvent<String>.Element, ControlEvent<IndexPath>.Element)>
    }
    struct Output {
        let movieList: Observable<[String]>
        let recentList: BehaviorSubject<[String]>
        let tableViewEvent: Observable<String>
    }
    
    func transform(_ input: Input) -> Output {
        let recentList = BehaviorSubject(value:recentList)
        
        input.recentText
            .subscribe(with: self) { owner, value in
                owner.recentList.append(value)
                recentList.onNext(owner.recentList)
            }
            .disposed(by: disposeBag)
        input.searchBarText
            .bind(with: self) { owner, value in
                print("value")
            }
            .disposed(by: disposeBag)
        input.searchButtonTap
            .bind(with: self) { owner, value in
                print("searchButtonTap")
            }
            .disposed(by: disposeBag)
       let tableViewEvent = input.tableViewEvent
            .map {"\($0.0)"}
           
        
        return Output(movieList: movieList, recentList: recentList, tableViewEvent: tableViewEvent)
    }
}
