//
//  NetworkSession.swift
//  Reciplease
//
//  Created by Stéphane Rihet on 08/06/2022.
//

import Foundation
import Alamofire

protocol NetWorkerProtocol {
    func request(url: URL, completionHandler: @escaping(DataResponse<RecipeData, AFError>)->Void)
}

 class NetWorker: NetWorkerProtocol {
    func request(url: URL, completionHandler: @escaping (DataResponse<RecipeData, AFError>) -> Void) {
        let request = AF.request(url) { $0.timeoutInterval = 10 }.validate()
        request.responseDecodable(completionHandler: completionHandler)
    }
    }
