//
//  ModelOfInventoryList.swift
//  Introventoria
//
//  Created by Sullivan Dupre on 4/13/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import Foundation
import CoreData

public class ModelOfInventoryList{
    let managedObjectContext:NSManagedObjectContext?
    
    var dataStoredInModel = [InventoryItems]()
    
    init(context: NSManagedObjectContext)
    {
        managedObjectContext = context
    }
    
    func fetchDataForModel()->Int{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InventoryItems")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        dataStoredInModel = ((try? managedObjectContext!.fetch(fetchRequest)) as? [InventoryItems])!
        
        return dataStoredInModel.count
    }
    
    func clearAllCoreData()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "InventoryItems")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext!.execute(deleteRequest)
            try managedObjectContext!.save()
        }
        catch let _ as NSError {
            // Handle error
        }
    }
    
    func addItemToList(name: String, descriptionOfItem: String, barcode: String, numberOfUnits: String){
        
        let ent = NSEntityDescription.entity(forEntityName: "InventoryItems", in: self.managedObjectContext!)
        let item = InventoryItems(entity: ent!, insertInto: managedObjectContext)
        
        item.name = name
        item.descriptionOfItem = descriptionOfItem
        item.barcode = barcode
        item.numberOfUnits = numberOfUnits
        
        do {
            try managedObjectContext!.save()
            print("Item Saved")
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
