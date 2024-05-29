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
    
    private var repo: any DataRepository
    
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: ShoppingListViewModel
    @State private var isPresentingAddItemView = false
    @State private var showOnlyBoughtItems = false
    
    var emptyStateMessage: String {
        if self.viewModel.searchText.isEmpty {
            return showOnlyBoughtItems ? "Your bought items list is as empty as my fridge just water bottles 😄" : "Your shopping list is empty. Start adding items by tapping the '+' button."
        } else {
            return "We couldn't find any matches for your search."
        }
    }
    
    // MARK: Initializer
    
    init(repo: any DataRepository) {
        self.repo = repo
        self.viewModel = ShoppingListViewModel(repo: self.repo)
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
            AddItemView(repo: self.repo, isPresented: $isPresentingAddItemView)
                .accessibility(identifier: AccessibilityIdentifiers.addItemView)
        }
        .alert(isPresented: $viewModel.isShowingError) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")) {
                viewModel.isShowingError = false
            })
        }
        .onAppear {
            viewModel.getAllItems()
        }
    }
}

// MARK: - Subviews

extension ShoppingListView {
    
    // MARK: Sorting Menu
    
    private var SortingMenu: some View {
        Menu {
            Button(action: {
                self.viewModel.sort(by: .ascending)
            }) {
                Label("Sort Ascending", systemImage: self.viewModel.sortOrder == .ascending ? "checkmark" : "")
            }
            Button(action: {
                self.viewModel.sort(by: .descending)
            }) {
                Label("Sort Descending", systemImage: self.viewModel.sortOrder == .descending ? "checkmark" : "")
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
            if viewModel.filteredItems.isEmpty {
                EmptyStateView
            } else {
                ForEach(viewModel.filteredItems) { item in
                    NavigationLink {
                        EditItemView(repo: self.repo, item: item)
                            .navigationBarTitle("Edit Item", displayMode: .automatic)
                    } label: {
                        ShoppingItemView(item: item) {
                            self.viewModel.updateIsBought(for: item)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
        }
        .searchable(text: $viewModel.searchText)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !viewModel.filteredItems.isEmpty {
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
        .onChange(of: self.showOnlyBoughtItems) { oldValue, newValue in
            self.viewModel.filter(by: newValue)
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
                viewModel.deleteItem(by: index)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ShoppingListView(repo: MockShoppingListRepository())
}
