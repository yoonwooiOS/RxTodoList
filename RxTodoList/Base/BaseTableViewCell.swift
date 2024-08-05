//
//  BaseTableViewCell.swift
//  RxTodoList
//
//  Created by 김윤우 on 8/5/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
