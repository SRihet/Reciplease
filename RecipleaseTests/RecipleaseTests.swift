//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by Stéphane Rihet on 27/05/2022.
//

import XCTest
@testable import Reciplease

class RecipleaseTests: XCTestCase {
    
    // MARK: - Properties
    
    var ingredientsList = ["Cheese", "milk"]
    var recipeManager: RecipeManager!
    var coreDataStack: MockCoreDataStack!
    var fakeNetworker: FakeNetworker!
    
    var expectation: XCTestExpectation!
    
    // MARK: - Tests Life Cycle
    
    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack()
        fakeNetworker = FakeNetworker()
        recipeManager = RecipeManager(networker: fakeNetworker)
        expectation = XCTestExpectation(description: "Expectation")
        _ = recipeManager.deleteAllRecordOnDatabase()
    }
    
    override func tearDown() {
        super.tearDown()
        _ = recipeManager.deleteAllRecordOnDatabase()
    }
    
    // MARK: - Tests
    
    func testNetWorkerPostFailedCallbackIfError() {
        fakeNetworker.state = .error
        
        recipeManager.getRecipes(ingredients: ingredientsList) { success, error in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertTrue(self.recipeManager.returnedRecipes.count == 0)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testNetWorkerFailedCallbackIfIncorrectData() {
        fakeNetworker.state = .incorrectData
        
        recipeManager.getRecipes(ingredients: ingredientsList) { success, error in
            XCTAssertFalse(success)
            XCTAssertNotNil(error)
            XCTAssertTrue(self.recipeManager.returnedRecipes.count == 0)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testNetWorkerPostSuccessCallbackIfCorrectDataAndNoError() {
        fakeNetworker.state = .correctData
        
        recipeManager.getRecipes(ingredients: ingredientsList) { success, error in
            XCTAssertTrue(success)
            XCTAssertNil(error)
            XCTAssertTrue(self.recipeManager.returnedRecipes.count > 0)
            let recipe = self.recipeManager.returnedRecipes.first
            XCTAssertEqual(recipe?.label, "Strong Cheese")
            XCTAssertEqual(recipe?.url, "http://notwithoutsalt.com/strong-cheese/")
            XCTAssertEqual(recipe?.yield, 8.0)
            XCTAssertEqual(recipe?.ingredientLines, ["1 lb left-over cheese, at room temperature",
                                                     "1/4 cup dry white wine",
                                                     "3 tbsp unsalted butter, softened",
                                                     "2 tbsp fresh parsley leaves",
                                                     "1 small clove garlic"])
            XCTAssertEqual(recipe?.image, "https://edamam-product-images.s3.amazonaws.com/web-img/53c/53ca837dcd939671920e6ab70ad723a6.jpg?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEDoaCXVzLWVhc3QtMSJHMEUCIQDTrn%2B1EupGMkM%2B7NYqvFwIQnfzmHaRU6fNQ218OEWa7wIgCeej%2BlgTqIRS7FQt2e4yUQOfeb%2FlhH1daFHw%2FJffgX4q0gQIcxAAGgwxODcwMTcxNTA5ODYiDAsFJLS3SYD%2FYFT2NiqvBF53RDGrl3bRpaaxOVRklT4rgzjZfyQr%2BpyhgJrJiK2SG1Podi2QDYO%2Bn424SmmhVAzAwf1Ixib6secFvUIl8ogYVzKzo4Ko7YQ29bKC3VgxMafyo%2FpX%2Bl9uV%2Bw%2Bk%2Bk8UamHhQxy7yHY7quRaLW4EDUIT4JvLxykV6M8WwEHSu2%2FxmXWF0NBipkHuUojNPr18cXpmHZt%2FSS%2BGkCqWa1IlcRSH5FwdTHCbP7mDuPbxs3M%2B4whrgi66O15dB4o478u9C0ndIG2y6dTfmIPHTcEyRQElH4zrFK6T2fNnn%2F85T3rQEb1newbsqdJwlcRpDWZNueLbLUDwHHcqs5WkKzQqSwUUf0du8uuI0HKhwbYOnsHSUvSH2GOP2%2Fghrl2Lg5Cz5xgOwxpDCwaxmZ1IL5p8%2BVNWYxaSYWLndX0RAt5UXzaxRBqkKfZopkBMzWEdtkMIlBDB4b5%2FF7Fy1IToSTFMEhtbiebJMQTyxKz2Ns6cpBxyb%2BbnWsWeWhOhmZMn16vKiH4%2FxqlP%2FrBHjOddRE9nz8KgUZHkNQLRPUKellG0H6lfXvUF6Imt%2F3LOke06Ev4YzPij7SLXv5UbIpcRKT%2FBJi%2BqPnUosrk%2FibF3GaYr1ne%2B3SJCutOOUJDdw0cjA2CLGCtyW0HAkpeJvrz%2F3XmTfjMqRTov%2BuGthDz1e7VgopTSRu3l2aYsvCyihRIyI7H0BXUyLRSEmpZkzDHxKvMpJDR8GYZGIxaZNSiQRcHO64w2p%2B6lgY6qQEhJfleqXkLw398NCNt6swbOdrBN%2BWECv%2BoYGoMTmwPmqztWweOyoCUR275sS96eAyQ%2BozIMnDP5XBkK8U9tudJe6YsoRVMaMs7jJOafAAUwEX%2BBSdFjWQDKiQwgmo%2B8yfnQN5Y0n2ieyTLRagVlms%2FPre%2Brn0txnz713V4ZRtjvvVH7mTcfZ4zBDbBYg4i17bvoJ3%2BJp%2FuIE7m9iNSSiUYMGEsll8b0cW%2F&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20220713T095544Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=ASIASXCYXIIFCXSEXBVI%2F20220713%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=5701adbbf3e4944b7e3bbc7d807f6ee6c1b399b281435a151cc2c234afdde5ca")
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAddRecipeMethodsThenShouldBeCorrectlySaved() {
        let fakeRecipe = Recipe(label: "Fake Recipe", image:  "https://fr.wikipedia.org/wiki/Fichier:Logo_OpenClassrooms.png", url: "https://www.openclassrooms.com", yield: 16, ingredientLines: ["big workday", "250gr Swift"], ingredients: [Ingredients(food: "Apple"), Ingredients(food: "Sugar")], totalTime: 40, favorite: true)
        var recipeIsFavorite = recipeManager.selectedRecipeIsFavorite
        XCTAssertFalse(recipeIsFavorite)
        addFakeRecipeToCoreData(recipe: fakeRecipe)
        XCTAssertFalse(recipeManager.favoritesRecipes.isEmpty)
        XCTAssertTrue(recipeManager.favoritesRecipes.count == 1)
        XCTAssertTrue(recipeManager.favoritesRecipes[0].label == "Fake Recipe")
        XCTAssertTrue(recipeManager.favoritesRecipes[0].ingredientLines[1] == "250gr Swift")
        XCTAssertTrue(recipeManager.favoritesRecipes[0].yield == 16)
        XCTAssertTrue(recipeManager.favoritesRecipes[0].totalTime == 40)
        XCTAssertTrue(recipeManager.favoritesRecipes[0].image == "https://fr.wikipedia.org/wiki/Fichier:Logo_OpenClassrooms.png")
        XCTAssertTrue(recipeManager.favoritesRecipes[0].url == "https://www.openclassrooms.com")
        
        recipeIsFavorite = recipeManager.selectedRecipeIsFavorite
        XCTAssertTrue(recipeIsFavorite)
    }
    
    func testAddRecipeMethodsThenShouldBeNotSaved() {
        
        recipeManager.selectedRecipe = nil
        let isSaved = recipeManager.saveRecipeOnDatabase()
        XCTAssertTrue(recipeManager.favoritesRecipes.isEmpty)
        XCTAssertFalse(isSaved)
        
    }
    
    func testDeleteRecipeMethodThenShouldBeCorrectlyDeleted() {
        
        let fakeRecipe = Recipe(label: "Fake Recipe", image:  "https://fr.wikipedia.org/wiki/Fichier:Logo_OpenClassrooms.png", url: "https://www.openclassrooms.com", yield: 16, ingredientLines: ["big workday", "250gr Swift"], ingredients: [Ingredients(food: "Work"), Ingredients(food: "Swift")], totalTime: 40, favorite: true)
        addFakeRecipeToCoreData(recipe: fakeRecipe)
        XCTAssertTrue(recipeManager.selectedRecipeIsFavorite)
        XCTAssertFalse(recipeManager.favoritesRecipes.isEmpty)
        let deleteSuccces =  deleteFakeRecipeToCoreData()
        XCTAssertTrue(deleteSuccces)
        XCTAssertFalse(recipeManager.selectedRecipeIsFavorite)
        XCTAssertTrue(recipeManager.favoritesRecipes.isEmpty)
    }
    
    func testDeleteAllRecipesMethodThenShouldBeCorrectlyDeleted() {
        
        let fakeRecipeOne = Recipe(label: "Fake RecipeOne", image:  "https://fr.wikipedia.org/wiki/Fichier:Logo_OpenClassrooms.png", url: "https://www.openclassrooms.com", yield: 1, ingredientLines: ["big workday", "250gr Swift"], ingredients: [Ingredients(food: "Apple"), Ingredients(food: "Swift")], totalTime: 11, favorite: true)
        addFakeRecipeToCoreData(recipe: fakeRecipeOne)
        let fakeRecipeTwo = Recipe(label: "Fake RecipeTwo", image:  "https://fr.wikipedia.org/wiki/Fichier:Logo_OpenClassrooms.png", url: "https://www.openclassrooms.com", yield: 2, ingredientLines: ["big workday", "250gr Swift"], ingredients: [Ingredients(food: "Work"), Ingredients(food: "Swift")], totalTime: 22, favorite: true)
        addFakeRecipeToCoreData(recipe: fakeRecipeTwo)
        XCTAssertFalse(recipeManager.favoritesRecipes.isEmpty)
        let deleteSuccces =  deleteAllRecipeToCoreData()
        XCTAssertTrue(deleteSuccces)
        XCTAssertFalse(recipeManager.selectedRecipeIsFavorite)
        XCTAssertTrue(recipeManager.favoritesRecipes.isEmpty)
    }
    
    private func addFakeRecipeToCoreData(recipe: Recipe) {
        recipeManager.selectedRecipe = recipe
        _ = recipeManager.saveRecipeOnDatabase()
    }
    
    private func deleteFakeRecipeToCoreData() -> Bool{
        return recipeManager.deleteRecordOnDatabase()
    }
    
    private func deleteAllRecipeToCoreData() -> Bool{
        return recipeManager.deleteAllRecordOnDatabase()
    }
    
}
