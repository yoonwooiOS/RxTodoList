//
//  ReuseIdentifier.swift
//  RxTodoList
//
//  Created by 김윤우 on 8/5/24.
//

import Foundation

extension NSObjectProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
