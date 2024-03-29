//
//  SearchRecipeViewController.swift
//  Prueba_Amaris
//
//  Created by Wilson Jair Tique Aguja on 10/07/23.
//

import UIKit
import CoreData

class SearchRecipeViewController: UIViewController {
    //MARK: Variables
    var ingredients = [Ingredient]()
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Ingredient>!
    //MARK: IBOutlets
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Ingredients"
        setupFetchedResultsController()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    //MARK: Setting up FetchedResultsController
    fileprivate func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("THE FETCH FAILED: \(error.localizedDescription)")
        }
        fetchedResultsController.delegate = self
    }
    
    //MARK: Presenting Alert to add new ingredients
    func presentNewIngredientAlert() {
        let alert = UIAlertController(title: "New Ingredient", message: "Enter a name for this ingredient", preferredStyle: .alert)
        
        // Create actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            if let name = alert.textFields?.first?.text {
                self?.addIngredient(name: name)
            }
        }
        saveAction.isEnabled = false
        
        // Add a text field
        alert.addTextField { textField in
            textField.placeholder = "Name"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main) { notif in
                if let text = textField.text, !text.isEmpty {
                    saveAction.isEnabled = true
                } else {
                    saveAction.isEnabled = false
                }
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    //MARK: Adding and removing ingredients
    func addIngredient(name: String) {
        let ingredient = Ingredient(context: dataController.viewContext)
        ingredient.name = name
        try? dataController.viewContext.save()
    }
    
    func deleteIngredint(at indexPath: IndexPath){
        let ingredientToDelete = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(ingredientToDelete)
        try? dataController.viewContext.save()
    }
    
    //MARK: IBActions
    @IBAction func addButtonPressed(_ sender: Any) {
        presentNewIngredientAlert()
    }
    @IBAction func searchRecipeButtonPressed(_ sender: Any) {
        if self.ingredientsTableView.numberOfRows(inSection: 0) > 0 {
            self.performSegue(withIdentifier: "goToRecipe", sender: Any.self)
        } else {
            let alert = UIAlertController(title: "No ingredients found", message: "Please enter ingredients first.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    //MARK: Prepare for segue to pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToRecipe"){
            let recipeVC = segue.destination as! RecipeTableViewController
            recipeVC.ingredients = fetchedResultsController.fetchedObjects
        }
    }
    
}

//MARK:- TableViewDelegate and TableViewDataSource methods
extension SearchRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ingredient = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTableViewCell
        cell.ingredientLabel.text = ingredient.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteIngredint(at: indexPath)
        default: ()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        }
    }
}

//MARK: - NSFetchedResultsController Delegate Methods
extension SearchRecipeViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.ingredientsTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.ingredientsTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.ingredientsTableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            self.ingredientsTableView.deleteRows(at: [indexPath!], with: .fade )
            break
        default:
            break
        }
    }
}

