//
//  ItemTableViewCell.swift
//  Introventoria
//
//  Created by Sullivan Dupre on 4/13/20.
//  Copyright © 2020 ASU. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var itemTitleVar: UILabel!
    @IBOutlet weak var UnitsInStockConstant: UILabel!
    @IBOutlet weak var itemCellNumberVar: UILabel!
    @IBOutlet weak var itemCellBarcodeVar: UILabel!
    @IBOutlet weak var UnitBarcodeConstant: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
