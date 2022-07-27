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
    
    // MARK: Public
    // MARK: Properties

    private let coreDataManager = CoreDataManager()
    private var netWorker: NetWorker
    
    var selectedRecipe: Recipe? {
        didSet {
            if let recipe = selectedRecipe, coreDataManager.checkIfRecipeIsFavorite(recipe: recipe) {
                selectedRecipe!.favorite = true
            }
        }
    }
    
    var selectedRecipeIsFavorite: Bool {
        guard let recipe = selectedRecipe else { return false }
        return coreDataManager.checkIfRecipeIsFavorite(recipe: recipe)
    }
    
    private var _returnededRecipes: [Recipe] = []
    var returnedRecipes: [Recipe] { _returnededRecipes }
    
    var favoritesRecipes: [Recipe] {
        return coreDataManager.favoritesRecipes
    }
    
    init(networker: NetWorker = NetWorker()) {
        netWorker = networker
    }
    
    // MARK: Methods
    func getRecipes(ingredients: [String], completionHandler: @escaping ((Bool) -> Void)) {
        guard let url = _createRequest(withIngredients: ingredients) else {
            completionHandler(false)
            return
        }
        
        netWorker.request(url: url) { [weak self] response in
            guard let self = self else { return }
            var isASuccess = false
            switch response.result {
            case .success:
                if let hits = response.value  {
                    self._returnededRecipes = hits.hits.map{$0.recipe}
                    isASuccess = true
                }
            case .failure:
                break
            }
            completionHandler(isASuccess)
        }
    }
    
    func saveRecipeOnDatabase() -> Bool {
        guard let recipe = selectedRecipe else { return false }
        if coreDataManager.saveRecipe(recipe: recipe) {
            selectedRecipe!.favorite = true
        } else {
            return false
        }
        return true
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
    
    // MARK: Methods
    /// Configure the URL with parameters
    private func _createRequest(withIngredients ingredients: [String]) -> URL? {
        let params = ["q": ingredients.joined(separator: ","), "app_id": appId, "app_key": appKey, "type": "public"]

        guard var components = URLComponents(string: url) else { return nil }

        components.queryItems = [URLQueryItem]()
        for (key, value) in params {
            components.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        return components.url
    }
}
