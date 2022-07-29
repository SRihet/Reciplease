//
//  IngredientsTableViewCell.swift
//  Reciplease
//
//  Created by Stéphane Rihet on 01/06/2022.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {
    
    // MARK: IBOutlet
    @IBOutlet private weak var ingredientLabel: UILabel!
    @IBOutlet weak var emojiIcon: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(ingredient: String) {
        ingredientLabel.text = "- \(ingredient)"
        applyAccessibility()
    }
    
    func applyAccessibility() {
        ingredientLabel.accessibilityLabel = ingredientLabel.text
        ingredientLabel.accessibilityHint = "Name of the ingredients"
        ingredientLabel.font =
            .preferredFont(forTextStyle: .body)
        ingredientLabel.adjustsFontForContentSizeCategory = true
        emojiIcon.isAccessibilityElement = false
    }
}
