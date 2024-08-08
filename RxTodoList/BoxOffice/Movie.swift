//
//  Movie.swift
//  RxTodoList
//
//  Created by 김윤우 on 8/8/24.
//

import Foundation

struct Movie: Decodable {
    let boxOfficeResult: boxOfficeResult
}

struct boxOfficeResult: Decodable {
    let dailyBoxOfficeList: [DailyBoxOfficeList]
}

struct DailyBoxOfficeList: Decodable {
    let movieNm: String
    let openDt: String
}
