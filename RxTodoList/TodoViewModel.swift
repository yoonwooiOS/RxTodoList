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
    lazy var list = BehaviorRelay(value:data)
    let disposeBag = DisposeBag()
    struct Input {
        let cellCheckButtonTapped: PublishRelay<Int>
        let cellLikeButtonTapped: PublishRelay<Int>
        let addTodo:  Observable<ControlProperty<String>.Element>
    }
    struct Output {
        let TodoList: BehaviorRelay<[Todo]>
        
    }
    
    
    func transform(input: Input) -> Output {
        input.cellLikeButtonTapped
            .bind(with: self) { owner, idx in
                owner.data[idx].likeState.toggle()
                owner.list.accept(self.data)
            }
            .disposed(by: disposeBag)
        input.cellCheckButtonTapped
            .bind(with: self) { owner, idx in
                owner.data[idx].checkState.toggle()
                owner.list.accept(self.data)
            }
            .disposed(by: disposeBag)
        input.addTodo
            .bind(with: self) { owner, text in
                let data = Todo(name: text, checkState: false, likeState: false)
                owner.data.insert(data, at: 0)
                owner.list.accept(owner.data)
            }
            .disposed(by: disposeBag)
            
        return Output(TodoList: list)
    }
    
}
