//
//  FakeNetWorker.swift
//  RecipleaseTests
//
//  Created by Stéphane Rihet on 13/07/2022.
//

import Foundation
import Alamofire
@testable import Reciplease

class FakeNetworker: NetWorker {
    private let fakeResponse =  FakeResponseData()
    var state: FakeResponseData.SessionStatus = .correctData
    
    override func request(url: URL, completionHandler: @escaping (DataResponse<RecipeData, AFError>) -> Void) {
        let result = FakeResponseData.getCorrectData()
        let urlRequest = URLRequest(url: url)
        let resultat = Alamofire.AFError.responseSerializationFailed(reason: .inputFileNil)
        switch state {
        case .error, .incorrectData:
            completionHandler(DataResponse(request: urlRequest, response: FakeResponseData.responseData.response, data: FakeResponseData.responseData.data, metrics: .none, serializationDuration: 0, result: .failure(resultat)))
        case .correctData:
            completionHandler((DataResponse(request: urlRequest, response: FakeResponseData.responseData.response, data: FakeResponseData.responseData.data, metrics: .none, serializationDuration: 10, result: .success(result))))
        }
    }
}
