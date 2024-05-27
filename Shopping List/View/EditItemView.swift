//
//  EditItemView.swift
//  Shopping List
//
//  Created by Mohamed Farid on 27/05/2024.
//

import SwiftUI

struct EditItemView: View {
    
    // MARK: Properties
    
    @Environment(\.presentationMode) private var presentationMode
    @State private var name: String
    @State private var itemDescription: String
    @State private var quantity: Int
    
    @Bindable var item: Item
    
    // MARK: Initializers
    
    init(item: Item) {
        self.item = item
        _name = State(initialValue: item.name)
        _itemDescription = State(initialValue: item.itemDescription)
        _quantity = State(initialValue: item.quantity)
    }
    
    // MARK: Body
    
    var body: some View {
        Form {
            Section(header: Text("Item Details").font(.subheadline)) {
                TextField("Name", text: $name)
                    .frame(height: 40)
                TextField("Description", text: $itemDescription)
                    .frame(height: 40)
                Stepper(value: $quantity, in: 0...100) {
                    Text("Quantity: \(quantity)")
                        .frame(height: 40)
                }
            }
        }
        .navigationBarItems(trailing: Button("Save") {
            updateItem()
        })
    }
}

// MARK: - Methods

extension EditItemView {
    
    // MARK: Update Item
    
    private func updateItem() {
        item.name = name
        item.itemDescription = itemDescription
        item.quantity = quantity
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Preview

#Preview {
    EditItemView(item: Item(name: "", itemDescription: "", quantity: 0))
}
