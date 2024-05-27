//
//  ShoppingListView.swift
//  Shopping List
//
//  Created by Mohamed Farid on 27/05/2024.
//

import SwiftUI
import SwiftData

struct ShoppingListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showOnlyBoughtItems = false
    @Query(filter: #Predicate<Item> { !$0.isBought }) private var items: [Item]
    @Query(filter: #Predicate<Item> { $0.isBought }) private var boughtItems: [Item]
    @State private var isPresentingAddItemView = false
    
    var filteredItems: [Item] {
        showOnlyBoughtItems ? boughtItems : items
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Toggle("Show Bought Items Only", isOn: $showOnlyBoughtItems)
                    .font(.callout)
                    .padding([.horizontal, .top])
                List {
                    if (showOnlyBoughtItems ? boughtItems : items).isEmpty {
                        Text("Your shopping list is empty. Start adding items by tapping the '+' button.")
                            .foregroundColor(.secondary)
                            .padding()
                            .multilineTextAlignment(.center)
                            .frame(alignment: .center)
                    } else {
                        ForEach(filteredItems) { item in
                            NavigationLink {
                                EditItemView(item: item)
                                    .navigationBarTitle("Edit Item", displayMode: .automatic)
                            } label: {
                                ShoppingItemView(item: item)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if !filteredItems.isEmpty {
                            EditButton()
                        }
                    }
                    ToolbarItem {
                        Button(action: { isPresentingAddItemView.toggle() }) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
            }
            .navigationBarTitle("Shopping List", displayMode: .inline)
        }
        .sheet(isPresented: $isPresentingAddItemView) {
            AddItemView(isPresented: $isPresentingAddItemView)
                .environment(\.modelContext, modelContext)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredItems[index])
            }
        }
    }
}

#Preview {
    ShoppingListView()
}
