//
//  CoreDataManager.swift
//  Reciplease
//
//  Created by Stéphane Rihet on 27/05/2022.
//

import CoreData

final class CoreDataManager {
    
    // MARK: - Properties
    private let coreDataStack = CoreDataStack()
    private var managedObjectContext: NSManagedObjectContext {
        return coreDataStack.mainContext
    }
    
    var recipes: [MyRecipe] {
        let request: NSFetchRequest<MyRecipe> = MyRecipe.fetchRequest()
        guard let recipes = try? managedObjectContext.fetch(request) else { return [] }
        return recipes
    }
    
    var favoritesRecipes: [Recipe] {
        recipes.map { favorite in
            Recipe(label: favorite.label!,
                   image: favorite.image ?? "",
                   url: favorite.url ?? "",
                   yield: Double(favorite.yield),
                   ingredientLines: favorite.ingredientLines!,
                   ingredients: (favorite.ingredients?.map({ ingredient in
                Ingredients(food: ingredient)
            }))!,
                   totalTime: Double(favorite.totalTime),
                   favorite: true)
        }
    }
    
    // MARK: - Initializer
    init() {
    }
    
    // MARK: - Manage Entity
    func saveRecipe(recipe: Recipe) -> Bool {
        guard !checkIfRecipeIsFavorite(recipe: recipe) else { return false }
        let savedRecipe = MyRecipe(context: managedObjectContext)
        savedRecipe.label = recipe.label
        if let url = recipe.image {
            savedRecipe.image = url
        }
        savedRecipe.ingredientLines = recipe.ingredientLines
        savedRecipe.totalTime = Int32(recipe.totalTime)
        savedRecipe.yield = Int32(recipe.yield)
        savedRecipe.ingredients = recipe.ingredients.compactMap {$0.food}
        savedRecipe.isFavorite = true
        savedRecipe.url = recipe.url
        return coreDataStack.saveContext()
    }
    
    func deleteAllRecipes() -> Bool {
        recipes.forEach { managedObjectContext.delete($0) }
        return coreDataStack.saveContext()
    }
    
    func deleteRecipe(recipe: Recipe) -> Bool {
        let request: NSFetchRequest<MyRecipe> = MyRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "label == %@", recipe.label)
        request.predicate = NSPredicate(format: "url == %@", recipe.url ?? "")
        
        if let entity = try? managedObjectContext.fetch(request) {
            entity.forEach { managedObjectContext.delete($0) }
        }
        return coreDataStack.saveContext()
    }
    
    func checkIfRecipeIsFavorite(recipe: Recipe) -> Bool {
        let request: NSFetchRequest<MyRecipe> = MyRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "label == %@", recipe.label)
        request.predicate = NSPredicate(format: "url == %@", recipe.url ?? "")
        
        guard let count = try? managedObjectContext.count(for: request), count != 0 else { return false }
        return true
    }
}
