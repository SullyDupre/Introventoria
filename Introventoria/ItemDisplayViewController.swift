//
//  ItemDisplayViewController.swift
//  Introventoria
//
//  Created by Sullivan Dupre on 4/13/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit
import CoreData

class ItemDisplayViewController: UIViewController {
    
    var selectedItem : InventoryItems!
    var modelSelected: ModelOfInventoryList!
    var countSelected: Int!
    var listSelected = [InventoryItems]()
    var tableSent: UITableView!
    var selectedObj: NSManagedObjectContext!
    var selectedInd: Int!
    
    
    
    @IBOutlet weak var displayNumber: UILabel!
    @IBOutlet weak var displayDescription: UILabel!
    @IBOutlet weak var displayBarcode: UILabel!
    @IBOutlet weak var diplayName: UILabel!
    @IBOutlet weak var newDes: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.diplayName.text = selectedItem.name
        self.displayDescription.text = selectedItem.descriptionOfItem
        self.displayBarcode.text = selectedItem.barcode
        self.displayNumber.text = selectedItem.numberOfUnits
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func change(_ sender: Any) {
        
        self.selectedObj.delete(self.listSelected[selectedInd])
        self.listSelected.remove(at: selectedInd)
        
        self.modelSelected?.addItemToList(name: "New", descriptionOfItem: "New", barcode: "New", numberOfUnits: "New")
        
        countSelected = (self.modelSelected?.fetchDataForModel())!
        listSelected = self.modelSelected!.dataStoredInModel
        tableSent.reloadData()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
