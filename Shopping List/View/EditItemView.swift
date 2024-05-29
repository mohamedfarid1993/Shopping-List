//
//  EditItemView.swift
//  Shopping List
//
//  Created by Mohamed Farid on 27/05/2024.
//

import SwiftUI

struct EditItemView: View {
    
    // MARK: Properties
    
    private var repo: any DataRepository
    
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var viewModel: EditItemViewModel
    @State private var name: String
    @State private var itemDescription: String
    @State private var quantity: Int
    
    var item: Item
    
    // MARK: Initializers
    
    init(repo: any DataRepository, item: Item) {
        self.item = item
        self.repo = repo
        _name = State(initialValue: item.name)
        _itemDescription = State(initialValue: item.itemDescription)
        _quantity = State(initialValue: item.quantity)
        self.viewModel = EditItemViewModel(repo: repo)
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
        let newItem = Item(id: item.id, name: name, itemDescription: itemDescription, quantity: quantity, isBought: item.isBought)
        self.viewModel.update(newItem)
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Preview

#Preview {
    EditItemView(repo: MockShoppingListRepository(), item: Item(name: "", itemDescription: "", quantity: 0))
}
