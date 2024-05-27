//
//  ShoppingListView.swift
//  Shopping List
//
//  Created by Mohamed Farid on 27/05/2024.
//

import SwiftUI
import SwiftData

struct ShoppingListView: View {
    
    // MARK: Properties
    
    @Environment(\.modelContext) private var modelContext
    @State private var showOnlyBoughtItems = false
    @Query private var items: [Item]
    @State private var isPresentingAddItemView = false
    
    var filteredItems: [Item] {
        if showOnlyBoughtItems {
            (try? items.filter(#Predicate<Item> { $0.isBought })) ?? []
        } else {
            (try? items.filter(#Predicate<Item> { !$0.isBought })) ?? []
        }
    }
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            VStack {
                Toggle("Show Bought Items Only", isOn: $showOnlyBoughtItems)
                    .font(.callout)
                    .padding([.horizontal, .top])
                ListWithToolbar
            }
            .navigationBarTitle("Shopping List", displayMode: .inline)
        }
        .sheet(isPresented: $isPresentingAddItemView) {
            AddItemView(isPresented: $isPresentingAddItemView)
                .environment(\.modelContext, modelContext)
        }
    }
}

// MARK: - Subviews

extension ShoppingListView {
    
    // MARK: List With Toolbar
    
    private var ListWithToolbar: some View {
        List {
            if filteredItems.isEmpty {
                EmptyStateView
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
    
    // MARK: Empty State View
    
    private var EmptyStateView: some View {
        Text("Your shopping list is empty. Start adding items by tapping the '+' button.")
            .foregroundColor(.secondary)
            .padding()
            .multilineTextAlignment(.center)
            .frame(alignment: .center)
    }
}

// MARK: - Methods
 
extension ShoppingListView {
    
    // MARK: Delete Items
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(filteredItems[index])
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ShoppingListView()
}
