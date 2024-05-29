//
//  AddItemView.swift
//  Shopping List
//
//  Created by Mohamed Farid on 27/05/2024.
//

import SwiftUI

struct AddItemView: View {
    
    // MARK: Properties
    
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    @State private var name: String = ""
    @State private var itemDescription: String = ""
    @State private var quantity: Int = 0
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Details").font(.subheadline)) {
                    TextField("Name", text: $name)
                        .frame(height: 40)
                        .accessibility(identifier: AccessibilityIdentifiers.addItemNameTextField)
                    TextField("Description", text: $itemDescription)
                        .frame(height: 40)
                        .accessibility(identifier: AccessibilityIdentifiers.addItemDescriptionTextField)
                    Stepper(value: $quantity, in: 0...100) {
                        Text("Quantity: \(quantity)")
                    }
                    .frame(height: 40)
                    .accessibility(identifier: AccessibilityIdentifiers.addItemQuantityStepper)

                }
            }
            .navigationBarTitle("Add New Item", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            }, trailing: Button("Save") {
                validateAndSaveItem()
            }.accessibility(identifier: AccessibilityIdentifiers.addItemSaveButton))
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

// MARK: - Methods

extension AddItemView {
    
    // MARK: Validate Item
    
    private func validateAndSaveItem() {
        guard !name.isEmpty else {
            alertMessage = "Name cannot be empty."
            showAlert = true
            return
        }
        
        guard !itemDescription.isEmpty else {
            alertMessage = "Description cannot be empty."
            showAlert = true
            return
        }
        
        guard quantity > 0 else {
            alertMessage = "Quantity must be greater than zero."
            showAlert = true
            return
        }
        
        addItem()
        isPresented = false
    }
    
    // MARK: Add Item
    
    private func addItem() {
        let newItem = Item(name: name, itemDescription: itemDescription, quantity: quantity)
        modelContext.insert(newItem)
    }
}

// MARK: - Preview

#Preview {
    AddItemView(isPresented: Binding.constant(true))
}
