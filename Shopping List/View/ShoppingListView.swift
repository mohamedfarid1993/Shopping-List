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
    @State private var sortOrder: SortOrder = .none
    
    var filteredItems: [Item] {
        if sortOrder == .none {
            return (try? items.filter(#Predicate<Item> { showOnlyBoughtItems ? $0.isBought : !$0.isBought })) ?? []
        } else if sortOrder == .ascending {
            return (try? items.filter(#Predicate<Item> { showOnlyBoughtItems ? $0.isBought : !$0.isBought }).sorted(by: { $0.quantity < $1.quantity })) ?? []
        } else {
            return (try? items.filter(#Predicate<Item> { showOnlyBoughtItems ? $0.isBought : !$0.isBought }).sorted(by: { $0.quantity > $1.quantity })) ?? []
        }
    }
    
    enum SortOrder {
        case none, ascending, descending
    }
    
    // MARK: Body
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    SortingMenu
                    Spacer()
                    ToggleView
                }
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
    
    // MARK: Sorting Menu
    
    private var SortingMenu: some View {
        Menu {
            Button(action: {
                sortOrder = .ascending
            }) {
                Label("Sort Ascending", systemImage: sortOrder == .ascending ? "checkmark" : "")
            }
            Button(action: {
                sortOrder = .descending
            }) {
                Label("Sort Descending", systemImage: sortOrder == .descending ? "checkmark" : "")
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
        }
        .padding(.trailing)
    }
    
    // MARK: Toggle View
    
    private var ToggleView: some View {
        HStack {
            Toggle("", isOn: $showOnlyBoughtItems)
            Text("Bought Items")
                .font(.callout)
                .lineLimit(1)
        }
    }
    
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
