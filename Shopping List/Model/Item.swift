//
//  Item.swift
//  Shopping List
//
//  Created by Mohamed Farid on 27/05/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    
    // MARK: Properties
    
    @Attribute(.unique) var id: UUID
    var name: String
    var itemDescription: String
    var quantity: Int
    var isBought: Bool
    
    // MARK: Initializers
    
    init(name: String, itemDescription: String, quantity: Int, isBought: Bool = false) {
        self.id = UUID()
        self.name = name
        self.itemDescription = itemDescription
        self.quantity = quantity
        self.isBought = isBought
    }
}
