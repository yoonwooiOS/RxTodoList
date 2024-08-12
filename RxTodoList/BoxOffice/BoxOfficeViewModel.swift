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
    private var recentList: [String] = ["12","12"]
    
    struct Input {
        let recentText: PublishSubject<String>
        let searchBarText: ControlProperty<String>
        let searchButtonTap: ControlEvent<Void>
        let tableViewEvent: Observable<(ControlEvent<String>.Element, ControlEvent<IndexPath>.Element)>
    }
    struct Output {
        let movieList: PublishSubject<[DailyBoxOfficeList]>
        let recentList: BehaviorSubject<[String]>
        let tableViewEvent: Observable<String>
    }
    
    func transform(_ input: Input) -> Output {
        let recentList = BehaviorSubject(value:recentList)
        let boxOfficeList = PublishSubject<[DailyBoxOfficeList]>()
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
            .throttle(.seconds(1), scheduler: MainScheduler.instance) // 1초 지연
            .withLatestFrom(input.searchBarText)
            .distinctUntilChanged()
            .map {
                guard let intText = Int($0) else {
                    return 202040807
                }
                return intText
            }
            .map { return "\($0)"}
            .flatMap { value in
                NetworkManeger.shared.fetchMovie(date: value)
                    .catch { error in
                        let movie = Movie(boxOfficeResult: boxOfficeResult(dailyBoxOfficeList: []))
                        return Single.just(movie)
                    }
            }
            .subscribe(with: self) { owner, value in
                dump(value)
                boxOfficeList.onNext(value.boxOfficeResult.dailyBoxOfficeList)
            } onError: { owner, error in
                print("Network Error \(error)")
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }
            .disposed(by: disposeBag)
        
       let tableViewEvent = input.tableViewEvent
            .map {"\($0.0)"}
           
        
        return Output(movieList: boxOfficeList , recentList: recentList, tableViewEvent: tableViewEvent)
    }
}
