//
//  EditItemView.swift
//  Shopping List
//
//  Created by Mohamed Farid on 27/05/2024.
//

import SwiftUI

struct EditItemView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var name: String
    @State private var itemDescription: String
    @State private var quantity: Int
    
    @Bindable var item: Item
    
    init(item: Item) {
        self.item = item
        _name = State(initialValue: item.name)
        _itemDescription = State(initialValue: item.itemDescription)
        _quantity = State(initialValue: item.quantity)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Item Details")) {
                TextField("Name", text: $name)
                TextField("Description", text: $itemDescription)
                Stepper(value: $quantity, in: 0...100) {
                    Text("Quantity: \(quantity)")
                }
            }
        }
        .navigationBarItems(trailing: Button("Save") {
            updateItem()
        })
    }
    
    private func updateItem() {
        item.name = name
        item.itemDescription = itemDescription
        item.quantity = quantity
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    EditItemView(item: Item(name: "", itemDescription: "", quantity: 0))
}
