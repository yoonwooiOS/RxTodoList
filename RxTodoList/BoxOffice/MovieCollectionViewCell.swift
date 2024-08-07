//
//  MovieCollectionViewCell.swift
//  RxTodoList
//
//  Created by 김윤우 on 8/7/24.
//

import UIKit
import SnapKit

class MovieCollectionViewCell: BaseCollectionViewCell {
    let movieTextLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    override func setUpHierarchy() {
        contentView.addSubview(movieTextLabel)
    }
    override func setUpLayout() {
        movieTextLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
    }
}
