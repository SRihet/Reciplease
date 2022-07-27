//
//  RecipleaseAlert.swift
//  Reciplease
//
//  Created by Stéphane Rihet on 08/06/2022.
//

import Foundation

enum RecipleaseAlert {
    case ingredientListIsEmpty
    case recipeErrorNetwork
    case saveRecipeFailed
    case deleteRecipeFailed
    case noRecipeResult


    public var title: String {
        switch self {
        case .ingredientListIsEmpty,.recipeErrorNetwork, .saveRecipeFailed, .deleteRecipeFailed:
            return "Error"
        case .noRecipeResult:
            return "Warning"
        }
    }

    public var message: String {
        switch self {
        case .ingredientListIsEmpty:
            return "Your ingredient list is empty."
        case .recipeErrorNetwork:
            return "The recipes could not be loaded. Thank you try later!"
        case .saveRecipeFailed:
            return "The recipe could not be added to your favourites."
        case .deleteRecipeFailed:
            return "The recipe could not be deleted to your favourites."
        case .noRecipeResult:
            return "Please, check your ingredients spelling"
        }
    }
}
