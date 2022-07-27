//
//  FavoritesViewController.swift
//  Reciplease
//
//  Created by Stéphane Rihet on 03/06/2022.
//

import UIKit

class RecipeListViewController: UIViewController {
    
    @IBOutlet weak var clearFavoritesButton: UIBarButtonItem!
    @IBOutlet weak var listRecipesTableView: UITableView!
    
    @IBOutlet weak var noFavoritesView: UIView!
    // MARK: Properties
    
    var recipeManager = RecipeManager()
    var isFavorite = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listRecipesTableView.delegate = self
        listRecipesTableView.dataSource = self

        listRecipesTableView.register(UINib.init(nibName: "RecipesTableViewCell", bundle: nil), forCellReuseIdentifier: "RecipesTableViewCell")

        updateTrashButtonStatus()
        applyAccessibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listRecipesTableView.reloadData()
        checkIfEmpty()

        updateTrashButtonStatus()
        applyAccessibility()
    }
    
    func applyAccessibility() {
        listRecipesTableView.accessibilityLabel = "List of recipes"
        listRecipesTableView.accessibilityHint = "Displays all recipe"
        if isFavorite {
            listRecipesTableView.accessibilityValue = "List of your favorite recipes"
            self.navigationController?.tabBarItem.isAccessibilityElement = true
            self.navigationController?.tabBarItem.accessibilityLabel = "Favorite section"
        } else {
            listRecipesTableView.accessibilityValue = "List of  recipes with your ingredients"
            self.navigationController?.tabBarItem.isAccessibilityElement = true
            self.navigationController?.tabBarItem.accessibilityLabel = "Search section"
        }



        self.navigationController?.tabBarItem.isAccessibilityElement = true
        self.navigationController?.tabBarItem.accessibilityLabel = "Search section"
    }
    
    func checkIfEmpty() {
        if isFavorite {
            if recipeManager.favoritesRecipes.count == 0 {
                noFavoritesView?.isHidden = false
            } else {
                noFavoritesView?.isHidden = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SegueToDetailsRecipe", let recipesDetailsVC = segue.destination as? RecipesDetailsViewController else { return }
        recipesDetailsVC.recipeManager = recipeManager
    }
    
    
    @IBAction func deleteAll(_ sender: Any) {
        if !recipeManager.deleteAllRecordOnDatabase() {
            self.presentAlert(alert: .deleteRecipeFailed)
        }
        
        updateTrashButtonStatus()
        listRecipesTableView.reloadData()
        checkIfEmpty()
    }
    
    
    private func updateTrashButtonStatus() {
        if isFavorite {
            if recipeManager.favoritesRecipes.count == 0 {
                clearFavoritesButton.tintColor = .clear
                clearFavoritesButton.isAccessibilityElement = false
            } else {
                clearFavoritesButton.tintColor = UIColor(named: "CustomColor2")
                clearFavoritesButton.isAccessibilityElement = true
                clearFavoritesButton.accessibilityLabel = "Button for clear all recipes in your favorites"
            }
        }else {
            self.navigationItem.rightBarButtonItem = nil
        }
        }
}

extension RecipeListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFavorite {
            recipeManager.selectedRecipe = recipeManager.favoritesRecipes[indexPath.row]
        } else{
            recipeManager.selectedRecipe = recipeManager.returnedRecipes[indexPath.row]
        }

        performSegue(withIdentifier: "SegueToDetailsRecipe", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFavorite {
            return recipeManager.favoritesRecipes.count
        } else {
            return recipeManager.returnedRecipes.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipesTableViewCell", for: indexPath) as? RecipesTableViewCell else {
            return UITableViewCell()
        }
        if isFavorite {
            cell.configureCell(recipe: recipeManager.favoritesRecipes[indexPath.row])
        } else {
            cell.configureCell(recipe: recipeManager.returnedRecipes[indexPath.row])
        }

        
        return cell
    }
}

