//
//  ViewController.swift
//  Introventoria
//
//  Created by Sullivan Dupre on 4/13/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var modelCopy: ModelOfInventoryList?
    
    var dataStoredInView = [InventoryItems]()
    var updatedCountOfDataStoredInView = 0
    
    var itemToEdit = ""
    
    var latestItemDescription = ""
    var latestItemBarcode = ""
    var latestItemNumber = ""
    
    @IBOutlet weak var tableOfItems: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelCopy = ModelOfInventoryList(context: managedObjectContext)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addItemToTable(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Item", message: "Enter Item Name, Description, Barcode, and Number of Units in Inventory", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter Name of the item here"
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter Description of the item here"
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Type or Scan Barcode for item here"
        })
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Type or number of units for the item here"
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            let name = alert.textFields![0] as UITextField
            let descript = alert.textFields![1] as UITextField
            let barcode = alert.textFields![2] as UITextField
            let numberOfItems = alert.textFields![3] as UITextField
            if let nameText = name.text, let descriptText = descript.text, let barcodeText = barcode.text, let numberText = numberOfItems.text {
                self.modelCopy?.addItemToList(name: nameText, descriptionOfItem: descriptText, barcode: barcodeText, numberOfUnits: numberText)
                self.updatedCountOfDataStoredInView = (self.modelCopy?.fetchDataForModel())!
                self.dataStoredInView = self.modelCopy!.dataStoredInModel
                
                self.tableOfItems.reloadData()
            }
        }))
        
        self.present(alert, animated: true)
    }
    
    
    @IBAction func removeAllFromTable(_ sender: UIBarButtonItem) {
        let deleteAllAlert = UIAlertController(title: "Warning", message: "Are You Sure you want to delete all items?", preferredStyle: .alert)
        let dataInputAction = UIAlertAction(title: "Yes, Delete All", style: .default) { (aciton) in
            self.modelCopy?.clearAllCoreData()
            self.updatedCountOfDataStoredInView = (self.modelCopy?.fetchDataForModel())!
            self.dataStoredInView = self.modelCopy!.dataStoredInModel
            
            self.tableOfItems.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "No, Don't Delete", style: .default) { (aciton) in
            
        }
        
        deleteAllAlert.addAction(dataInputAction)
        deleteAllAlert.addAction(cancelAction)
        
        self.present(deleteAllAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func printConsoleDebug(_ sender: UIBarButtonItem) {
        print(dataStoredInView.count)
        for item in dataStoredInView{
            print("\(item.name ?? ""); described: \(item.descriptionOfItem ?? ""); barcode: \(item.barcode ?? ""); numberOfItems:\(item.numberOfUnits ?? "")")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        updatedCountOfDataStoredInView = (modelCopy?.fetchDataForModel())!
        dataStoredInView = modelCopy!.dataStoredInModel
        print(updatedCountOfDataStoredInView)
        
        return updatedCountOfDataStoredInView
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfItem", for: indexPath) as! ItemTableViewCell
        
        cell.layer.borderWidth = 1.0

        cell.itemTitleVar.text = dataStoredInView[indexPath.row].name
        cell.itemCellBarcodeVar.text = dataStoredInView[indexPath.row].barcode
        cell.itemCellNumberVar.text = dataStoredInView[indexPath.row].numberOfUnits
        
        cell.UnitBarcodeConstant.text = "Item Barcode: "
        cell.UnitsInStockConstant.text = "Number of Units: "
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        updatedCountOfDataStoredInView = (modelCopy?.fetchDataForModel())!
        dataStoredInView = modelCopy!.dataStoredInModel
        
        
        let deleteSwipe = UIContextualAction(style: .normal, title: "Delete Item"){ (action, view, nil) in
            let deleteAlert = UIAlertController(title: "Warning", message: "Are You Sure you want to delete this item?", preferredStyle: .alert)
            let dataInputAction = UIAlertAction(title: "Yes, Delete", style: .default) { (aciton) in
                self.updatedCountOfDataStoredInView = (self.modelCopy?.fetchDataForModel())!
                self.dataStoredInView = self.modelCopy!.dataStoredInModel
                
                self.managedObjectContext.delete(self.dataStoredInView[indexPath.row])
                self.dataStoredInView.remove(at: indexPath.row)
                
                do {
                    // save the updated managed object context
                    try self.managedObjectContext.save()
                } catch {
                    
                }
                
                
                self.tableOfItems.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "No, Don't Delete", style: .default) { (aciton) in
                
            }
            
            deleteAlert.addAction(dataInputAction)
            deleteAlert.addAction(cancelAction)
            
            self.present(deleteAlert, animated: true, completion: nil)
            
        }
        
        deleteSwipe.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return UISwipeActionsConfiguration(actions: [deleteSwipe])
         
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        
        updatedCountOfDataStoredInView = (modelCopy?.fetchDataForModel())!
        dataStoredInView = modelCopy!.dataStoredInModel
        
        itemToEdit = dataStoredInView[indexPath.row].name!
        latestItemDescription = dataStoredInView[indexPath.row].descriptionOfItem!
        latestItemBarcode = dataStoredInView[indexPath.row].barcode!
        latestItemNumber = dataStoredInView[indexPath.row].numberOfUnits!
        
        let numberSwipe = UIContextualAction(style: .normal, title: "Edit Number Of Units"){ (action, view, nil) in
            
            let alert = UIAlertController(title: "Edit Item Number Of Units", message: "Update the number of Units for this Item", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = self.latestItemNumber
            })
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                if let newNumberOfItems = alert.textFields?.first?.text {
                    self.managedObjectContext.delete(self.dataStoredInView[indexPath.row])
                    self.dataStoredInView.remove(at: indexPath.row)
                    
                    self.modelCopy?.addItemToList(name: self.itemToEdit, descriptionOfItem: self.latestItemDescription, barcode: self.latestItemBarcode, numberOfUnits: newNumberOfItems)
                    
                    self.updatedCountOfDataStoredInView = (self.modelCopy?.fetchDataForModel())!
                    self.dataStoredInView = self.modelCopy!.dataStoredInModel
                    
                    self.tableOfItems.reloadData()
                    
                }
            }))
            self.present(alert, animated: true)
            
        }
        let barcodeSwipe = UIContextualAction(style: .normal, title: "Edit Barcode"){ (action, view, nil) in
            let alert = UIAlertController(title: "Edit Item Barcode", message: "Type or Use a Scanner to Edit Item Barcode", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = self.latestItemBarcode
            })
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                if let newBarcode = alert.textFields?.first?.text {
                    self.managedObjectContext.delete(self.dataStoredInView[indexPath.row])
                    self.dataStoredInView.remove(at: indexPath.row)
                    
                    self.modelCopy?.addItemToList(name: self.itemToEdit, descriptionOfItem: self.latestItemDescription, barcode: newBarcode, numberOfUnits: self.latestItemNumber)
                    
                    self.updatedCountOfDataStoredInView = (self.modelCopy?.fetchDataForModel())!
                    self.dataStoredInView = self.modelCopy!.dataStoredInModel
                    
                    self.tableOfItems.reloadData()
                    
                }
            }))
            self.present(alert, animated: true)
            
        }
        let descriptSwipe = UIContextualAction(style: .normal, title: "Edit Description"){ (action, view, nil) in
            let alert = UIAlertController(title: "Edit Item Description", message: "Edit the Description of the Item", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = self.latestItemDescription
            })
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                if let newDescription = alert.textFields?.first?.text {
                    self.managedObjectContext.delete(self.dataStoredInView[indexPath.row])
                    self.dataStoredInView.remove(at: indexPath.row)
                    
                    self.modelCopy?.addItemToList(name: self.itemToEdit, descriptionOfItem: newDescription, barcode: self.latestItemBarcode, numberOfUnits: self.latestItemNumber)
                    
                    self.updatedCountOfDataStoredInView = (self.modelCopy?.fetchDataForModel())!
                    self.dataStoredInView = self.modelCopy!.dataStoredInModel
                    
                    self.tableOfItems.reloadData()
                    
                }
            }))
            self.present(alert, animated: true)
            
        }
        descriptSwipe.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        barcodeSwipe.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)
        numberSwipe.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return UISwipeActionsConfiguration(actions: [descriptSwipe, barcodeSwipe, numberSwipe])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueToDisplayItem"){
            
            updatedCountOfDataStoredInView = (modelCopy?.fetchDataForModel())!
            dataStoredInView = modelCopy!.dataStoredInModel
            
            let selectedIndex: IndexPath = self.tableOfItems.indexPath(for: sender as! UITableViewCell)!
            
            let itemToSend = dataStoredInView[selectedIndex.row]
            
            if let viewController: ItemDisplayViewController = segue.destination as? ItemDisplayViewController {
                viewController.selectedItem = itemToSend
                viewController.modelSelected = modelCopy
                viewController.listSelected = dataStoredInView
                viewController.countSelected = updatedCountOfDataStoredInView
                viewController.selectedObj = managedObjectContext
                viewController.tableSent = tableOfItems
                viewController.selectedInd = selectedIndex.row
                
            }
        }
    }


}

