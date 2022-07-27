//
//  RecipesTableViewCell.swift
//  Reciplease
//
//  Created by Stéphane Rihet on 01/06/2022.
//

import UIKit
import Kingfisher

class RecipesTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var recipeImageView: UIImageView!
    @IBOutlet private weak var titleRecipeLabel: UILabel!
    @IBOutlet private weak var ingredientsLabel: UILabel!
    @IBOutlet private weak var yieldLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(recipe: Recipe) {
        if let url = URL(string: recipe.image!) {
            self.recipeImageView.kf.setImage(with: url,
                                             placeholder: UIImage(named: "NoRecipeImage"))
        }
        titleRecipeLabel.text = recipe.label
        
        ingredientsLabel.text = recipe.ingredients.compactMap({$0.food}).joined(separator: ", ")
        yieldLabel.text = String(recipe.yield)
        timeLabel.text = String(recipe.totalTime)
        
        applyAccessibility()
    }
    
  func applyAccessibility() {
      recipeImageView.accessibilityTraits = .image
      recipeImageView.accessibilityLabel = "Image of the recipe"
      
      titleRecipeLabel.accessibilityLabel = titleRecipeLabel.text
      titleRecipeLabel.accessibilityHint = "Title of the recipe"
      titleRecipeLabel.font =
          .preferredFont(forTextStyle: .title3)
      titleRecipeLabel.adjustsFontForContentSizeCategory = true
      
      ingredientsLabel.accessibilityLabel = "List of the recipe"
      ingredientsLabel.accessibilityHint = "List of the recipe"
      ingredientsLabel.accessibilityValue = ingredientsLabel.text
      ingredientsLabel.font =
          .preferredFont(forTextStyle: .body)
      ingredientsLabel.adjustsFontForContentSizeCategory = true
      
      yieldLabel.accessibilityLabel = "\(String(describing: yieldLabel.text)) yield"
      yieldLabel.accessibilityHint = "the yield of this recipe"
      yieldLabel.font =
          .preferredFont(forTextStyle: .body)
      yieldLabel.adjustsFontForContentSizeCategory = true
      
      timeLabel.accessibilityLabel = "\(String(describing: timeLabel.text)) to prepare"
      timeLabel.accessibilityHint = "The time for prepare this recipe"
      timeLabel.font =
          .preferredFont(forTextStyle: .body)
      timeLabel.adjustsFontForContentSizeCategory = true
    }
}
