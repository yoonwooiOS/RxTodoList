//
//  TodoViewModel.swift
//  RxTodoList
//
//  Created by 김윤우 on 8/5/24.
//

import Foundation
import RxSwift
import RxCocoa
final class TodoViewModel {
    var data: [Todo] = [
        Todo(name: "그립톡 구매하기", checkState: true, likeState: true),
        Todo(name: "사이다 구매하기", checkState: false, likeState: false),
        Todo(name: "아이패드 케이스 최저가 알아보기", checkState: false, likeState: false)
    ]
    var recommandTodo = ["스위프트 공부", "올림픽 시청", "세차", "RxSwift 복습"]

    
    
    let disposeBag = DisposeBag()
    struct Input {
        
        let collectionViewEvent: PublishSubject<String>
        let recommandScedule: PublishSubject<String>
        let cellCheckButtonTapped: PublishRelay<Int>
        let cellLikeButtonTapped: PublishRelay<Int>
        let addTodo:  Observable<ControlProperty<String>.Element>
    }
    struct Output {
        let todoList: BehaviorSubject<[Todo]>
        let recommandList: BehaviorSubject<[String]>
        let collectionViewEvent:  PublishSubject<String>
    }
    
    func transform(input: Input) -> Output {
        
        let recommandList = BehaviorSubject(value: recommandTodo)
        
        let list = BehaviorSubject(value:data)
        input.cellLikeButtonTapped
            .bind(with: self) { owner, idx in
                owner.data[idx].likeState.toggle()
                list.onNext(self.data)
            }
            .disposed(by: disposeBag)
        input.cellCheckButtonTapped
            .bind(with: self) { owner, idx in
                owner.data[idx].checkState.toggle()
                list.onNext(self.data)
            }
            .disposed(by: disposeBag)
        input.addTodo
            .bind(with: self) { owner, text in
                let data = Todo(name: text, checkState: false, likeState: false)
                owner.data.insert(data, at: owner.data.endIndex)
                list.onNext(owner.data)
            }
            .disposed(by: disposeBag)
         input.collectionViewEvent
            .bind(with: self) { owner, value in
                
                owner.data.append(Todo(name: value, checkState: false, likeState: false))
                list.onNext(owner.data)
            }
            .disposed(by: disposeBag)
        return Output(todoList: list, recommandList: recommandList, collectionViewEvent: input.collectionViewEvent)
    }
    
}
