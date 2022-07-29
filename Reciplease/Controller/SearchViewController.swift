//
//  SearchViewController.swift
//  Reciplease
//
//  Created by Stéphane Rihet on 03/06/2022.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: IBOutlet
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var clearIngredientsButton: UIButton!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var searchRecipesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noIngredientsLabel: UILabel!
    @IBOutlet weak var yourIngredientsLabel: UILabel!
    
    // MARK: Properties
    private var ingredients: [String] = []
    private let recipeManager = RecipeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        
        ingredientsTableView.delegate = self
        ingredientsTextField.delegate = self
        ingredientsTableView.dataSource = self
        
        ingredientsTableView.register(UINib.init(nibName: "IngredientsTableViewCell", bundle: nil), forCellReuseIdentifier: "IngredientsTableViewCell")
        
        applyAccessibility()
        checkIfEmpty()
    }
    
    // MARK: IBAction
    @IBAction func addIngredientButton(_ sender: Any) {
        guard let ingredient = ingredientsTextField.text, !ingredient.isEmpty else { return }
        
        ingredients.append(ingredient)
        ingredientsTableView.reloadData()
        ingredientsTextField.text = ""
        ingredientsTextField.endEditing(true)
        checkIfEmpty()
    }
    
    @IBAction func clearAllIngredients(_ sender: Any) {
        ingredients.removeAll()
        ingredientsTableView.reloadData()
        checkIfEmpty()
    }
    
    @IBAction func searchRecipes(_ sender: Any) {
        if ingredients.isEmpty {
            self.presentAlert(alert: .ingredientListIsEmpty)
            return
        }
        
        activityIndicator.isHidden = false
        
        recipeManager.getRecipes(ingredients: ingredients){ [weak self] isSuccess, error in
            guard let self = self else { return }
            self.activityIndicator.isHidden = true
            
            if let error = error {
                if error as? RecipleaseError == RecipleaseError.recipeErrorNetwork {
                    self.presentAlert(alert: .recipeErrorNetwork)
                }
            }
            if isSuccess {
                if self.recipeManager.returnedRecipes.count > 0 {
                    self.performSegue(withIdentifier: "segueToRecipe", sender: self)
                }else {
                    self.presentAlert(alert: .noRecipeResult)
                }
                
            }
        }
        
        
    }
    
    // MARK: Methods
    func applyAccessibility() {
        ingredientsTextField.accessibilityLabel = "Ingredients textfield"
        ingredientsTextField.accessibilityHint = "Enter your ingredients"
        ingredientsTextField.font =
            .preferredFont(forTextStyle: .body)
        ingredientsTextField.adjustsFontForContentSizeCategory = true
        
        addButton.accessibilityLabel = "Button for add ingredients"
        addButton.accessibilityHint = "Adds ingredients in your list"
        addButton.titleLabel!.font =
            .preferredFont(forTextStyle: .title2)
        addButton.titleLabel!.adjustsFontForContentSizeCategory = true
        
        clearIngredientsButton.accessibilityLabel = "Button for clean your ingredients list"
        clearIngredientsButton.accessibilityHint = "Deletes all ingredients of your list"
        clearIngredientsButton.titleLabel!.adjustsFontForContentSizeCategory = true
        
        ingredientsTableView.accessibilityLabel = "List of your ingredients"
        ingredientsTableView.accessibilityValue = "List of your ingredients"
        ingredientsTableView.accessibilityHint = "Displays all recipe"
        
        searchRecipesButton.accessibilityLabel = "Button for search recipe"
        searchRecipesButton.accessibilityHint = "Search recipe with your ingredients"
        searchRecipesButton.titleLabel!.font =
            .preferredFont(forTextStyle: .title2)
        searchRecipesButton.titleLabel!.adjustsFontForContentSizeCategory = true
        
        yourIngredientsLabel.font =
            .preferredFont(forTextStyle: .title2)
        yourIngredientsLabel.adjustsFontForContentSizeCategory = true
        
        noIngredientsLabel.font =
            .preferredFont(forTextStyle: .title3)
        noIngredientsLabel.adjustsFontForContentSizeCategory = true
        
        self.navigationController?.tabBarItem.isAccessibilityElement = true
        self.navigationController?.tabBarItem.accessibilityLabel = "Search section"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func checkIfEmpty() {
        if ingredients.count == 0 {
            noIngredientsLabel.isHidden = false
            clearIngredientsButton.isHidden = true
        } else {
            noIngredientsLabel.isHidden = true
            clearIngredientsButton.isHidden = false
        }
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "segueToRecipe", let recipeListVC = segue.destination as? RecipeListViewController else { return }
        recipeListVC.recipeManager = recipeManager
        recipeListVC.isFavorite = false
    }
}


    // MARK: TableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell", for: indexPath) as? IngredientsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(ingredient: ingredients[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            checkIfEmpty()
        }
    }
}
