//
//  NetworkService.swift
//  NASA-Apod
//
//  Created by Saurav Kedia on 26/05/21.
//

import UIKit

protocol NetworkServiceProtocol {
    func getAPODInfo(apodKey:String, success: @escaping(Data?) -> Void, failure: @escaping(Error?) -> Void)
    func downloadMedia(url:URL, success: @escaping(Data?) -> Void, failure: @escaping(Error?) -> Void)
}

class NetworkService: NSObject, NetworkServiceProtocol {
    
    static let API_PATH = "https://api.nasa.gov/planetary/apod"
    
    func getAPODInfo(apodKey:String, success: @escaping (Data?) -> Void, failure: @escaping (Error?) -> Void) {
        fetchAPODInfo(apodKey:apodKey, success: success, failure: failure)
    }
    
    private func fetchAPODInfo(apodKey:String, success: @escaping (Data?) -> Void, failure: @escaping (Error?) -> Void) {
        let endPoint = "\(NetworkService.API_PATH)?api_key=\(apodKey)"
        guard let url = URL(string: endPoint) else {
            failure(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                failure(error)
                return
            }
            success(data)
        }
        task.resume()
    }
    
    func downloadMedia(url: URL, success: @escaping (Data?) -> Void, failure: @escaping (Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                failure(error)
                return
            }
            success(data)
        }
        task.resume()
    }
}
