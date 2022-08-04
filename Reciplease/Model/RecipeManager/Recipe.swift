//
//  Recipe.swift
//  Reciplease
//
//  Created by Stéphane Rihet on 27/05/2022.
//

import Foundation

struct RecipeData: Codable {
    let hits: [Hits]
}

// MARK: - Hit

struct Hits: Codable {
    let recipe: Recipe
}

// MARK: - Recipe

struct Recipe: Codable {
    let label: String
    let image: String?
    let url: String?
    let yield: Double
    let ingredientLines: [String]
    let ingredients: [Ingredients]
    let totalTime: Double
}
struct Ingredients: Codable {
    let food: String
}
