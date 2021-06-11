//
//  API.swift
//  PracticeRx
//
//  Created by 三浦　登哉 on 2021/06/10.
//

import Foundation
import RxSwift
import RxCocoa

final class API {
    static let shared = API()
    private init (){}
    
    func getRepositoly(searchWord: String, completion: ((Result<[GithubModel], GithubError>) -> Void)? = nil) {
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(searchWord)&sort=stars") else { return }
        let task = URLSession.shared.dataTask(with: url) { (date, response, error) in
            guard let date = date else { return }
            guard let repos = try? JSONDecoder().decode(Item.self, from: date) else { return }
            guard let repo = repos.items else { return }
            completion?(.success(repo))
            
            if error != nil {
                completion?(.failure(.networkError))
            }
        }
        task.resume()
    }
}
