//
//  APIRequest.swift
//  YoutubeApp
//
//  Created by Tatsushi Fukunaga on 2021/03/04.
//

import Foundation
import Alamofire

class API {
    
    enum PathType: String {
        case search
        case channels
    }
    
    static let shared = API()
    
    private let baseUrl = "https://www.googleapis.com/youtube/v3/"
    
    func request<T: Decodable>(path: PathType, params: [String: Any], type: T.Type, completion: @escaping (T) -> Void) {
        
        let path = path.rawValue
        let url = baseUrl + path + "?"
        
        var params = params
        params["key"] = "AIzaSyB9QUjcXauoSNhnGUFU_RqEfzUU70Z87SU"
        params["part"] = "snippet"
        
        let request = AF.request(url, method: .get, parameters: params)
        
        request.responseJSON { (response) in
            guard let statusCode = response.response?.statusCode else { return }
            if statusCode <= 300 {
                do {
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    let value = try decoder.decode(T.self, from: data)
                    
                    completion(value)
                } catch {
                    print("変換に失敗しました。：", error)
                }
            }
            
        }
    }
    
}
