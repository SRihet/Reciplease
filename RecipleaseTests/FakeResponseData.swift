//
//  FakeResponseData.swift
//  RecipleaseTests
//
//  Created by Stéphane Rihet on 13/07/2022.
//

import Foundation
import Alamofire
@testable import Reciplease

class FakeResponseData {
    private static let responseOk = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    private static let responseKO = HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    static func getCorrectData() -> RecipeData {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "CheeseRecipe", withExtension: ".json")
        let data = try! Data(contentsOf: url!)
        responseData.data = data
        responseData.error = nil
        responseData.response = responseOk
        let recipes = try! JSONDecoder().decode(RecipeData.self, from: data)
        return recipes
    }
    
    static var incorrectData: Data {
        get {
            responseData.data = nil
            responseData.response = responseKO
            responseData.error = AFError.explicitlyCancelled
            return "Error".data(using: .utf8)!
        }
    }
    static var responseData = FakeResponse()
    
    enum ResultStats {
        case error
        case correctData
        case incorrectData
    }
    
    struct FakeResponse {
        var response: HTTPURLResponse?
        var data: Data?
        var error: Error?
    }
}
