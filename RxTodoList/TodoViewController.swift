//
//  TodoViewController.swift
//  RxTodoList
//
//  Created by 김윤우 on 8/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TodoViewController: BaseViewController {
    private let textField = {
        let textField = UITextField()
        textField.addLeftPadding()
        textField.textColor = .black
        textField.placeholder = "무엇을 구매하실건가요?"
        textField.textAlignment = .left
        textField.borderStyle = .none
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .systemGray5
        return textField
    }()
    private let todoAddButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray4
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    private lazy var tableView = {
        let view = UITableView()
        view.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.identifier)
        view.rowHeight = 52
        view.separatorStyle = .none
        return view
    }()
    var data: [Todo] = [
        Todo(name: "그립톡 구매하기", checkState: true, likeState: true),
        Todo(name: "사이다 구매하기", checkState: false, likeState: false),
        Todo(name: "아이패드 케이스 최저가 알아보기", checkState: false, likeState: false)
    ]
    lazy var list = BehaviorRelay(value:data)
    let viewModel = TodoViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    override func setUpHierarchy() {
        view.addSubview(textField)
        view.addSubview(todoAddButton)
        view.addSubview(tableView)
    }
    override func setUpLayout() {
        textField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(56)
        }
        todoAddButton.snp.makeConstraints { make in
            make.top.trailing.bottom.equalTo(textField).inset(12)
            make.width.equalTo(60)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(12)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func setUpNavigationTitle() {
        navigationItem.title = "쇼핑"
    }
    private func bind() {
        
        let cellCheckButtonTapped = PublishRelay<Int>()
        let cellLikeButtonTapped = PublishRelay<Int>()
        let input = TodoViewModel.Input( cellCheckButtonTapped: cellCheckButtonTapped, cellLikeButtonTapped: cellLikeButtonTapped, addTodo: self.todoAddButton.rx.tap
            .withLatestFrom(self.textField.rx.text.orEmpty ))
        let output = viewModel.transform(input: input)
        
        output.TodoList
            .bind(to: tableView.rx.items(cellIdentifier: TodoTableViewCell.identifier, cellType: TodoTableViewCell.self)) {
                (row, element, cell ) in // let = row, let = element, let = cell -> 왜 let으로 선언되는지 알아보기
                var data = element
                print(element,"2312312312312")
                print(data,"!!!!!")
                cell.setUpCell(data: data)
                cell.checkButton.rx.tap
                    .map {row}
                    .bind(to: cellCheckButtonTapped)
                    .disposed(by: cell.disposeBag)
                cell.likeButton.rx.tap
                    .map {row}
                    .bind(to: cellLikeButtonTapped)
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
          
//        self.textField.rx.text.orEmpty
//            .bind(with: self) { owner, value in
//                let result = value.isEmpty ? owner.data : owner.data.filter { $0.name.contains(value)}
//                print(result)
//                owner.list.accept(result)
//            }
//            .disposed(by: disposeBag)
    }
}

