//
//  RecipesDetailsViewController.swift
//  Reciplease
//
//  Created by Stéphane Rihet on 03/06/2022.
//

import UIKit

class RecipesDetailsViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var backButton: UINavigationItem!
    
    // MARK: Properties
    var recipeManager = RecipeManager()
    let cellReuseIdentifier = "cell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let recipe = recipeManager.selectedRecipe else { return }
        
        self.ingredientsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
        if let url = URL(string: recipe.image!) {
            self.recipeImage.kf.setImage(with: url,
                                         placeholder: UIImage(named: "NoRecipeImage"))
        }
        recipeTitleLabel.text = recipe.label
        yieldLabel.text = String(recipe.yield)
        timeLabel.text = String(recipe.totalTime)
        applyAccessibility()
        updateFavoriteButtonStatus()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateFavoriteButtonStatus()
    }
    
    // MARK: IBAction
    @IBAction func getDirections(_ sender: Any) {
        guard let recipe = recipeManager.selectedRecipe else { return }
        
        if let url = URL(string: (recipe.url)!) {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func addFavorite(_ sender: Any) {
        guard let _ = recipeManager.selectedRecipe else { return }
        _updateDatabase()
        updateFavoriteButtonStatus()
    }
    
    // MARK: Methods
    func applyAccessibility() {
        recipeImage.accessibilityTraits = .image
        recipeImage.accessibilityLabel = "Image of the recipe"
        
        recipeTitleLabel.accessibilityLabel = recipeTitleLabel.text
        recipeTitleLabel.font =
            .preferredFont(forTextStyle: .title3)
        recipeTitleLabel.adjustsFontForContentSizeCategory = true
        recipeTitleLabel.accessibilityHint = "The title of recipe"
        
        ingredientsLabel.accessibilityLabel = ingredientsLabel.text
        ingredientsLabel.font =
            .preferredFont(forTextStyle: .body)
        ingredientsLabel.adjustsFontForContentSizeCategory = true
        
        yieldLabel.accessibilityLabel = "\(String(describing: yieldLabel.text)) yield"
        yieldLabel.font =
            .preferredFont(forTextStyle: .body)
        yieldLabel.adjustsFontForContentSizeCategory = true
        yieldLabel.accessibilityHint = "the yield of this recipe"
        
        timeLabel.accessibilityLabel = "\(String(describing: timeLabel.text)) to prepare"
        timeLabel.font =
            .preferredFont(forTextStyle: .body)
        timeLabel.adjustsFontForContentSizeCategory = true
        timeLabel.accessibilityHint = "The time for prepare this recipe"
        
        getDirectionsButton.accessibilityLabel = "Button for show directions recipe"
        getDirectionsButton.accessibilityHint = "Open webview with the directions"
        getDirectionsButton.titleLabel!.font =
            .preferredFont(forTextStyle: .title2)
        getDirectionsButton.titleLabel!.adjustsFontForContentSizeCategory = true
        getDirectionsButton.accessibilityTraits = .button
        
        favoriteButton.accessibilityTraits = .button
        
        ingredientsTableView.accessibilityLabel = "List of ingredients"
        ingredientsTableView.accessibilityHint = "Displays all ingredients of this recipe"
        ingredientsTableView.accessibilityValue = "List of ingredients"
        
        backButton.accessibilityLabel =  "Back button"
        backButton.accessibilityTraits = .button
        backButton.accessibilityHint = "Back"
        
        self.navigationController?.tabBarItem.isAccessibilityElement = true
        self.navigationController?.tabBarItem.accessibilityLabel = "Search section"
    }
    
    private func updateFavoriteButtonStatus() {
        if recipeManager.selectedRecipeIsFavorite {
            favoriteButton.tintColor = UIColor(named: "CustomColor2")
            favoriteButton.accessibilityLabel = "Button for delete recipe in your favorites"
            favoriteButton.accessibilityHint = ""
        } else {
            favoriteButton.tintColor = .gray
            favoriteButton.accessibilityLabel = "Button for add recipe in your favorites"
            favoriteButton.accessibilityHint = ""
        }
    }
    
    /// Update the database (save or delete the record)
    private func _updateDatabase() {
        if recipeManager.selectedRecipeIsFavorite {
            if !recipeManager.deleteRecordOnDatabase() {
                self.presentAlert(alert: .deleteRecipeFailed)
            }
        } else {
            if !recipeManager.saveRecipeOnDatabase() {
                self.presentAlert(alert: .saveRecipeFailed)
            }
        }
    }
    
}

// MARK: TableView
extension RecipesDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipeManager.selectedRecipe?.ingredientLines.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let ingredient = recipeManager.selectedRecipe?.ingredientLines[indexPath.row]
        cell.textLabel?.text = ingredient
        cell.backgroundColor = UIColor(named: "CustomColorBackground")
        
        return cell
    }
    
}
