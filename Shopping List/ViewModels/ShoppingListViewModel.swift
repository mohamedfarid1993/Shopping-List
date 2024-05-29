//
//  ShoppingListViewModel.swift
//  Shopping List
//
//  Created by Mohamed Farid on 29/05/2024.
//

import Foundation
import Combine

class ShoppingListViewModel: ObservableObject {
    @Published var items: [Item] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        ShoppingListRepository.shared.objectWillChange
            .sink { [weak self] _ in
                self?.getAllItems()
            }
            .store(in: &cancellables)
        
        getAllItems()
    }
    
    func getAllItems() {
        items = ShoppingListRepository.shared.getAll()
    }
    
    func addItem() {
        let newItem = Item(name: "New Item", itemDescription: "New Description", quantity: 1)
        ShoppingListRepository.shared.add(newItem)
    }
    
    func deleteItem(by index: IndexSet.Element) {
        ShoppingListRepository.shared.delete(withId: items[index].id)
    }
}
