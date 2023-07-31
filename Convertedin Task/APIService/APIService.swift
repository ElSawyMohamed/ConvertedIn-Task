//
//  APIService.swift
//  Convertedin Task
//
//  Created by Mohamed El Sawy on 28/07/2023.
//

import Foundation
import Alamofire

class APIService {
    
    private init() {}
    static let instance = APIService()
    
    func getData<ResponseType: Decodable>(_ endpoint: String,_ responseType: ResponseType.Type,_ params: Parameters = [:],_ urlEncoder : URLEncoding = URLEncoding.httpBody ,_ method: HTTPMethod = .get, completionHandler: @escaping (ResponseType?,String?) -> Void) {
        
        getAlamoRequest(url: NConstants.endpoint(endpoint), params ,method: method, ResponseType.self, urlEncoder) { (response, errorMessage, error) in
            if error != nil {
                completionHandler(nil,error?.localizedDescription ?? "Error".localized)
                return
            }
            if errorMessage.isEmpty == false {
                completionHandler(nil,errorMessage)
            } else {
                completionHandler(response,nil)
            }
        }
    }
    func getAlamoRequest<ResponseType: Decodable>(url: URL,_ params: Parameters,method: HTTPMethod = .get, _ responseType: ResponseType.Type,_ urlEncoder: URLEncoding = URLEncoding.httpBody, completion: @escaping (ResponseType?,String, Error?) -> Void) {
        
        let headers: HTTPHeaders = [
            .contentType("application/json"),
            .accept("application/json")
        ]
        
        let manager = Alamofire.Session()
        manager.request(url, method: method, parameters: params, encoding: urlEncoder , headers: headers)
            .validate(statusCode: 200..<500)
            .responseData { response in
                let decoder = JSONDecoder()
                switch response.result {
                case .success:
                    do {
                        let responseObject = try decoder.decode(ResponseType.self, from: response.data!)
                        DispatchQueue.main.async {
                            completion(responseObject,"",nil)
                        }
                    } catch {
                        print(error)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                    completion(nil,"",error)
                }
            }
            manager.session.invalidateAndCancel()
        }
    }
}

