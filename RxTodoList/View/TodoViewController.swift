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
    private let collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout())
        view.register(TodoCollectionViewCell.self, forCellWithReuseIdentifier: TodoCollectionViewCell.identifier)
        //        view.backgroundColor = .brown
        return view
    }()
    
    let viewModel = TodoViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    override func setUpHierarchy() {
        view.addSubview(textField)
        view.addSubview(todoAddButton)
        view.addSubview(collectionView)
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
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(12)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    override func setUpNavigationTitle() {
        navigationItem.title = "쇼핑"
    }
    private func bind() {
        let recommandScedule = PublishSubject<String>()
        let cellCheckButtonTapped = PublishRelay<Int>()
        let cellLikeButtonTapped = PublishRelay<Int>()
        let input = TodoViewModel.Input( 
            collectionViewEvent: recommandScedule ,
            recommandScedule: recommandScedule,
            cellCheckButtonTapped: cellCheckButtonTapped,
            cellLikeButtonTapped: cellLikeButtonTapped,
            addTodo: self.todoAddButton.rx.tap.withLatestFrom(self.textField.rx.text.orEmpty))
        let output = viewModel.transform(input: input)
        
        output.todoList
            .bind(to: tableView.rx.items(cellIdentifier: TodoTableViewCell.identifier, cellType: TodoTableViewCell.self)) {
                (row, element, cell ) in // let = row, let = element, let = cell -> 왜 let으로 선언되는지 알아보기
                let data = element
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
        output.recommandList
            .bind(to: collectionView.rx.items(cellIdentifier: TodoCollectionViewCell.identifier, cellType: TodoCollectionViewCell.self)) {
                (row, element, cell) in
                cell.todoLabel.text = element
                print(element)
                recommandScedule.onNext(element)
            }
            .disposed(by: disposeBag)
        collectionView.rx.modelSelected(String.self)
            .map {"\($0)"}
            .subscribe(with: self) { owner, value in
                print("collectionViewEvent\(value)")
                recommandScedule.onNext(value)
            }
            .disposed(by: disposeBag)
    }
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
}

