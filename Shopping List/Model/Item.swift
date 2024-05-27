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
    @Attribute(.unique) var id: UUID
    var name: String
    var itemDescription: String
    var quantity: Int
    
    init(name: String, itemDescription: String, quantity: Int) {
        self.id = UUID()
        self.name = name
        self.itemDescription = itemDescription
        self.quantity = quantity
    }
}
