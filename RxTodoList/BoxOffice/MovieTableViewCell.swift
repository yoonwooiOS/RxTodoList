//
//  MovieTableViewCell.swift
//  RxTodoList
//
//  Created by 김윤우 on 8/7/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class MovieTableViewCell: BaseTableViewCell {
        let baseUView = {
            let view = UIView()
            view.backgroundColor = .systemGray5
            view.layer.cornerRadius = 8
            return view
        }()
        let checkButton = {
            let button = UIButton()
            button.tintColor = .black
            return button
        }()
        let todoNameLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.textColor = .black
            return label
        }()
        let likeButton = {
            let button = UIButton()
            button.tintColor = .black
            return button
        }()
        var disposeBag = DisposeBag()
        
        override func prepareForReuse() {
            //구독 중첩 처리
            disposeBag = DisposeBag()
        }
        override func setUpHierarchy() {
            contentView.addSubview(baseUView)
            baseUView.addSubview(checkButton)
            baseUView.addSubview(todoNameLabel)
            baseUView.addSubview(likeButton)
        }
        override func setUpLayout() {
            baseUView.snp.makeConstraints { make in
                make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(12)
                make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(2)
            }
            checkButton.snp.makeConstraints { make in
                make.centerY.equalTo(baseUView)
                make.leading.equalTo(baseUView.safeAreaLayoutGuide).offset(20)
                make.size.equalTo(28)
            }
            todoNameLabel.snp.makeConstraints { make in
                make.centerY.equalTo(baseUView)
                make.leading.equalTo(checkButton.snp.trailing).offset(16)
            }
            likeButton.snp.makeConstraints { make in
                make.centerY.equalTo(baseUView)
                make.trailing.equalTo(baseUView.safeAreaLayoutGuide).inset(12)
                make.size.equalTo(28)
            }
        }
}
