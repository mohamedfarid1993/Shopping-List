//
//  ShoppingItemView.swift
//  Shopping List
//
//  Created by Mohamed Farid on 27/05/2024.
//

import SwiftUI

struct ShoppingItemView: View {
    @Bindable var item: Item

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
            Button(action: {
                withAnimation {
                    item.isBought.toggle()
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
        .padding(.vertical, 8)
    }
}

#Preview {
    ShoppingItemView(item: Item(name: "", itemDescription: "", quantity: 0))
}
