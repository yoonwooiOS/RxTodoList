//
//  TodoCollectionViewCell.swift
//  RxTodoList
//
//  Created by 김윤우 on 8/7/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TodoCollectionViewCell: BaseCollectionViewCell {
    let todoLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 12)
        label.layer.cornerRadius = 4
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    override func setUpHierarchy() {
        contentView.addSubview(todoLabel)
    }
    override func setUpLayout() {
        todoLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
    }
}
