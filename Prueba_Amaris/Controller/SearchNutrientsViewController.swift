//
//  SearchNutrientsViewController.swift
//   Prueba_Amaris
//
//  Created by Wilson Jair Tique Aguja on 10/07/23.
//

import UIKit
import Moya
import SwiftyJSON

class SearchNutrientsViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var dishNameTextField: UITextField!
    
    static let shared = SearchNutrientsViewController()
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dishNameTextField.delegate = self
        self.navigationItem.title = "Dish Name"
        setupNotifications()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        dishNameTextField.delegate = self
        self.navigationItem.title = "Dish Name"
        setupNotifications()
    }
    //MARK: IBActions
    @IBAction func searchRecipesButtonPressed(_ sender: Any) {
        if isCheckFieldEmpty() == false {
            self.performSegue(withIdentifier: "DishNameRecipes", sender: Any.self)
        }
    }
    
    @IBAction func searchNutrientValueButtonPressed(_ sender: Any) {
        if !isCheckFieldEmpty() {
            self.performSegue(withIdentifier: "getNutrientData", sender: Any.self)
        }
    }
    
    //MARK: Passing data to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "getNutrientData"){
            let nutri = segue.destination as! NutrientsViewController
            nutri.dishName = self.dishNameTextField.text
        }
        if segue.identifier == "DishNameRecipes" {
            let recipesVC = segue.destination as! RecipeTableViewController
            recipesVC.recipeByName = true
            recipesVC.dishName = self.dishNameTextField.text
        }
    }
    
    //MARK: Check TextFiled
    func isCheckFieldEmpty() ->Bool {
        if(dishNameTextField.text == ""){
            let alert = UIAlertController(title: "No dish name found", message: "Please enter the name of the dish first.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return true
        }
        return false
    }
}

extension SearchNutrientsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
