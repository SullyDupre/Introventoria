//
//  InventoryItems.swift
//  Introventoria
//
//  Created by Sullivan Dupre on 4/13/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import Foundation
import CoreData

public class InventoryItems: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var barcode: String?
    @NSManaged public var descriptionOfItem: String?
    @NSManaged public var numberOfUnits: String?
}
