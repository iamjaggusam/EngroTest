//
//  NewsRepository.swift
//  EngroTest
//
//  Created by JaGgu Sam on 06/12/22.
//

import Foundation

protocol NewsRespositoryProtocol {
    func getNews(date: String, completionHandler: @escaping (Result<NewsModel, TaskError>) -> Void)
}

class NewsRespository: NewsRespositoryProtocol {

    static let shared = NewsRespository()
    private init() {}

    func getNews(date: String, completionHandler: @escaping (Result<NewsModel, TaskError>) -> Void) {
        let url = APIConstants.baseURL + APIConstants.newsHeadlines //+ date + "&to=\(date)"
        let task = HTTPTask()
        task.GET(url: url) { (result: Result<NewsModel, TaskError>) -> Void in
            switch result {
                case .success(_, let statusCode):
                    if statusCode == 200 {
                        completionHandler(result)
                    }
                case .failure:
                    completionHandler(result)
                    break
            }
            
        }
    }
}
