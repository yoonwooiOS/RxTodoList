//
//  BaseCollectionViewCell.swift
//  RxTodoList
//
//  Created by 김윤우 on 8/7/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        setUpHierarchy()
        setUpLayout()
        setUpView()
        setUpCell()
    }
    
    func setUpHierarchy() { }
    func setUpLayout() { }
    func setUpView() { }
    func setUpCell() { }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
