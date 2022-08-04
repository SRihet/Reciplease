//
//  RecipeManager.swift
//  Reciplease
//
//  Created by Stéphane Rihet on 08/06/2022.
//

import Foundation
import Alamofire
import CoreData

class RecipeManager {
    
    // MARK: Properties
    private let coreDataManager = CoreDataManager()
    private var netWorker: NetWorker
    
    var selectedRecipe: Recipe?
    
    var selectedRecipeIsFavorite: Bool {
        guard let recipe = selectedRecipe else { return false }
        return coreDataManager.checkIfRecipeIsFavorite(recipe: recipe)
    }
    
    private var _returnedRecipes: [Recipe] = []
    var returnedRecipes: [Recipe] { _returnedRecipes }
    
    var favoritesRecipes: [Recipe] {
        return coreDataManager.favoritesRecipes
    }
    
    // MARK: - Initializer
    init(networker: NetWorker = NetWorker()) {
        netWorker = networker
    }
    
    // MARK: Methods
    func getRecipes(ingredients: [String], completionHandler: @escaping ((_ isSuccess: Bool, _ error: Error?) -> Void)) {
        guard let url = createRequest(withIngredients: ingredients) else {
            completionHandler(false, RecipleaseError.recipeErrorNetwork)
            return
        }
        
        netWorker.request(url: url) { [weak self] response in
            guard let self = self else { return }
            var isASuccess = false
            var error: Error?
            switch response.result {
            case .success:
                if let hits = response.value  {
                    self._returnedRecipes = hits.hits.map{$0.recipe}
                    isASuccess = true
                    error  = nil
                }
            case .failure:
                isASuccess = false
                error = RecipleaseError.recipeErrorNetwork
            }
            completionHandler(isASuccess, error)
        }
    }
    
    func saveRecipeOnDatabase() -> Bool {
        guard let recipe = selectedRecipe else { return false }
        if coreDataManager.saveRecipe(recipe: recipe) {
            return true
        } else {
            return false
        }
    }
    
    func deleteRecordOnDatabase() -> Bool {
        guard let selectedRecipe = selectedRecipe else { return false }
        
        if coreDataManager.deleteRecipe(recipe: selectedRecipe) {
            return true
        }else {
            return false
        }
    }
    
    func deleteAllRecordOnDatabase() -> Bool  {
        if coreDataManager.deleteAllRecipes() {
            return true
        }else {
            return false
        }
    }
    
    private func createRequest(withIngredients ingredients: [String]) -> URL? {
        let params = ["q": ingredients.joined(separator: ","), "app_id": appId, "app_key": appKey, "type": "public"]
        
        guard var components = URLComponents(string: url) else { return nil }
        
        components.queryItems = [URLQueryItem]()
        for (key, value) in params {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        return components.url
    }
}
