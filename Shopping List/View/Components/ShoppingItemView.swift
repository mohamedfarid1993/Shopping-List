//
//  ShoppingItemView.swift
//  Shopping List
//
//  Created by Mohamed Farid on 27/05/2024.
//

import SwiftUI

struct ShoppingItemView: View {
    
    // MARK: Properties
    
    var item: Item
    
    // MARK: Body

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.itemDescription)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Quantity: \(item.quantity)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            IsBoughtCheckBox
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Subview

extension ShoppingItemView {
    
    // MARK: - Is Bought Check Box
    
    private var IsBoughtCheckBox: some View {
        Button(action: {
            withAnimation {
                let newItem = Item(id: item.id, name: item.name, itemDescription: item.itemDescription, quantity: item.quantity, isBought: !item.isBought)
                ShoppingListRepository.shared.update(newItem)
            }
        }) {
            Image(systemName: item.isBought ? "checkmark.square.fill" : "square")
                .resizable()
                .foregroundColor(item.isBought ? .blue : .gray)
                .frame(width: 20, height: 20)
        }
        .padding(.trailing, 8)
        .buttonStyle(BorderlessButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    ShoppingItemView(item: Item(name: "", itemDescription: "", quantity: 0))
}
