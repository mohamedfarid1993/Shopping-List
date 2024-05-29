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
    @Query(filter: #Predicate<Item> { !$0.isBought }) private var items: [Item]
    @Query(filter: #Predicate<Item> { $0.isBought }) private var boughtItems: [Item]
    @State private var isPresentingAddItemView = false
    @State private var sortOrder: SortOrder = .none
    @State private var searchText = ""
    @State private var showOnlyBoughtItems = false
    
    var filteredItems: [Item] {
        let itemsToSort = showOnlyBoughtItems ? boughtItems : items
        let filteredItems = itemsToSort.filter { item in
            searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText) || item.itemDescription.localizedCaseInsensitiveContains(searchText)
        }
        
        switch sortOrder {
        case .ascending:
            return filteredItems.sorted(by: { $0.quantity < $1.quantity })
        case .descending:
            return filteredItems.sorted(by: { $0.quantity > $1.quantity })
        case .none:
            return filteredItems
        }
    }
    
    var emptyStateMessage: String {
        if searchText.isEmpty {
            return showOnlyBoughtItems ? "Your bought items list is as empty as my fridge just water bottles 😄" : "Your shopping list is empty. Start adding items by tapping the '+' button."
        } else {
            return "We couldn't find any matches for your search."
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
                .accessibility(identifier: AccessibilityIdentifiers.addItemView)
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
                .lineLimit(0)
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
        .searchable(text: $searchText)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !filteredItems.isEmpty {
                    EditButton()
                }
            }
            ToolbarItem {
                Button(action: { isPresentingAddItemView.toggle() }) {
                    Label("Add Item", systemImage: "plus")
                        .accessibility(identifier: AccessibilityIdentifiers.addItemButton)
                }
            }
        }
    }
    
    // MARK: Empty State View
    
    private var EmptyStateView: some View {
        Text(emptyStateMessage)
            .foregroundColor(.secondary)
            .padding()
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
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
