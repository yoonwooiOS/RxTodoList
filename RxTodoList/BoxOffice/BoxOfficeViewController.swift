//
//  BoxOfficeViewController.swift
//  RxTodoList
//
//  Created by 김윤우 on 8/7/24.
//

import UIKit
import RxSwift
import RxCocoa

class BoxOfficeViewController: BaseViewController {
    private let searchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    private let collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collectionView
    }()
    private let tableView = {
        let tableView = UITableView()
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.rowHeight = 80
        return tableView
    }()
   
    let viewModel = BoxOfficeViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
//        NetworkManeger.shared.callBoxOffice(date: "20240401")
//            .subscribe(with: self) { owner, value in
//                dump(value)
//            } onError: { owner, Error in
//                print("통신에러~ \(Error)")
//            } onCompleted: { owner in
//                print("onCompleted")
//            } onDisposed: { owner in
//                print("onDisposed")
//            }
//            .disposed(by: disposeBag)
    }
    private func bind() {
        let recentText = PublishSubject<String>()
        let input = BoxOfficeViewModel.Input(recentText: recentText, searchBarText: searchBar.rx.text.orEmpty, searchButtonTap: searchBar.rx.searchButtonClicked, tableViewEvent:  Observable.zip(tableView.rx.modelSelected(String.self), tableView.rx.itemSelected))
        let output = viewModel.transform(input)
        
        output.recentList
            .bind(to: collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)) { (row, element, cell) in
                cell.movieTextLabel.text = element
            }
            .disposed(by: disposeBag).self
        output.movieList
            .bind(to: tableView.rx.items(cellIdentifier: MovieTableViewCell.identifier, cellType: MovieTableViewCell.self)) {
                (row, element, cell) in
                dump(element.movieNm)
                cell.todoNameLabel.text = element.movieNm
                
            }
            .disposed(by: disposeBag)
       
        output.tableViewEvent
            .bind(with: self) { owner, value in
                recentText.onNext(value)
            }
            .disposed(by: disposeBag)
    }
    
    override func setUpHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(tableView)
    }
    override func setUpLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(4)
            make.height.equalTo(50)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(4)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
    override func setUpNavigationItems() {
        navigationItem.titleView = searchBar
    }
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
}
