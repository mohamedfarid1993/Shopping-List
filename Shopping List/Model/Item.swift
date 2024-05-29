//
//  Item.swift
//  Shopping List
//
//  Created by Mohamed Farid on 27/05/2024.
//

import UIKit
import CoreData

struct Item: Identifiable {
    
    // MARK: Properties
    
    var id: UUID
    var name: String
    var itemDescription: String
    var quantity: Int
    var isBought: Bool
    
    // MARK: Initializers
    
    init(id: UUID? = nil, name: String, itemDescription: String, quantity: Int, isBought: Bool = false) {
        self.id = id ?? UUID()
        self.name = name
        self.itemDescription = itemDescription
        self.quantity = quantity
        self.isBought = isBought
    }
}

// MARK: - NSManagedObject

extension NSManagedObject {
    
    // MARK: To Item Method
    
    func toItem() -> Item {
        return Item(id: self.value(forKey: "id") as? UUID,
                    name: self.value(forKey: "name") as! String,
                    itemDescription: self.value(forKey: "item_description") as! String,
                    quantity: self.value(forKey: "quantity") as! Int,
                    isBought: self.value(forKey: "is_bought") as!  Bool)
    }
}
