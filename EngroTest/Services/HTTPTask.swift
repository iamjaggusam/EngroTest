//
//  HTTPTask.swift
//  EngroTest
//
//  Created by JaGgu Sam on 06/12/22.
//

import Foundation

protocol HTTPTaskProtocol {
    func GET<T: Codable>(url: String, config: URLSessionConfiguration?, completionHandler: @escaping (Result<T, TaskError>) -> Void )
}

enum TaskError: Error {
    case httpError(code: String)
    case reachabilityError
    case jsonError
    case noData
    case other
}

enum Result<T, TaskError> {
    case success(T, Int?)
    case failure(TaskError, Int?)
}

enum ContentType: String {
    case json = "application/json"
    case text = "text/plain"
}

class HTTPTask: NSObject, HTTPTaskProtocol {
    
    func GET<T: Codable>(url: String,
                         config: URLSessionConfiguration? = nil,
                         completionHandler: @escaping (Result<T, TaskError>) -> Void ) {
        sendRequest(url, method: "GET", nil, completionHandler)
    }
    
}

func sendRequest<T: Codable>(_ url: String, method: String, _ data: Data?, contentType: ContentType = .json, sessionConfig: URLSessionConfiguration? = nil, _ completionHandler: @escaping (Result<T, TaskError>) -> Void) {
    
    guard let apiURL = URL(string: url) else { return }
    var urlRequest = URLRequest(url: apiURL)
    urlRequest.httpMethod = method
    
    if let data = data {
        urlRequest.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = data
    }
    
    urlRequest.timeoutInterval = 30
    
    let session = URLSession.shared
    let task = session.dataTask(with: urlRequest) { (data, response, error) in
 
        print("URL:", url)
        print("RESPONSE:", data as Any)
        print("ERROR:", error as Any)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {return}
        
        if error != nil {
            completionHandler(.failure(.other, statusCode))
            return
        }
        
        guard let jsonData = data, !jsonData.isEmpty else {
            completionHandler(.failure(.noData, statusCode))
            return
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let decoded = try? decoder.decode(T.self, from: jsonData) {
            DispatchQueue.main.async {
                completionHandler(.success(decoded, statusCode))
            }
        } else {
            DispatchQueue.main.async {
                completionHandler(.failure(.jsonError, statusCode))
            }
        }
        
    }
    
    task.resume()
    
}
