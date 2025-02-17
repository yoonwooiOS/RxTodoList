//
//  NetworkManeger.swift
//  RxTodoList
//
//  Created by 김윤우 on 8/8/24.
//

import Foundation
import RxSwift
import Alamofire

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

final class NetworkManeger {
    static let shared = NetworkManeger()
    private init() { }
    func callBoxOffice(date: String) -> Observable<Movie> {
        let url = APIURL.url + "\(date)"
        let result = Observable<Movie>.create { observer in
            guard let url = URL(string: url) else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(APIError.unknownResponse)
                    return
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.statusError)
                    return
                }
                if let data = data,
                   let appData = try? JSONDecoder().decode(Movie.self, from: data) {
                    observer.onNext(appData)
                    observer.onCompleted()
                } else {
                    print("error")
                    observer.onError(APIError.unknownResponse)
                }
            }
            .resume()
            return Disposables.create()
            }
            .debug("박스오피스 조회")
        return result
    }
    func fetchMovie(date: String) -> Single<Movie> {
        return Single.create { observer -> Disposable in
            let url = APIURL.url + "\(date)"
            AF.request(url).validate(statusCode: 200..<300).responseDecodable(of: Movie.self) { response in
                switch response.result {
                case .success(let success):
                    observer(.success(success))
                case .failure(let failure):
                    observer(.failure(failure))
                }
            }
            return Disposables.create()
        }.debug("Movie")
    }
}


