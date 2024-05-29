//
//  ShoppingListViewModel.swift
//  Shopping List
//
//  Created by Mohamed Farid on 29/05/2024.
//

import Foundation
import Combine

class ShoppingListViewModel: ObservableObject {
    
    // MARK: Properties
    
    @Published var items: [Item] = []
    @Published var isShowingError = false
    var errorMessage: String?
    private var cancellables: Set<AnyCancellable> = []
    private var repo: any DataRepository
    private var isBought = false
    
    // MARK: Initializers
    
    init(repo: any DataRepository) {
        self.repo = repo
        self.observeRepositoryUpdates()
    }
}

// MARK: - Data Management Methods

extension ShoppingListViewModel {
    
    private func observeRepositoryUpdates() {
        self.repo.objectWillChange
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.getAllItems()
            }
            .store(in: &self.cancellables)
    }
    
    func getAllItems() {
        self.repo.getAll()
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else { return }
                self?.errorMessage = error.localizedDescription
                self?.isShowingError = true
            } receiveValue: { [weak self] data in
                guard let self = self else { return }
                self.items = data
                self.items = items.filter({ $0.isBought == self.isBought })
            }
            .store(in: &self.cancellables)
    }
    
    func updateIsBought(for item: Item) {
        let newItem = Item(id: item.id,
                           name: item.name,
                           itemDescription: item.itemDescription,
                           quantity: item.quantity,
                           isBought: !item.isBought)
        self.repo.update(newItem)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else { return }
                self?.errorMessage = error.localizedDescription
                self?.isShowingError = true
            } receiveValue: { _ in }
            .store(in: &self.cancellables)
    }
    
    func deleteItem(by index: IndexSet.Element) {
        self.repo.delete(withId: items[index].id)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else { return }
                self?.errorMessage = error.localizedDescription
                self?.isShowingError = true
            } receiveValue: { _ in }
            .store(in: &self.cancellables)
    }
}

// MARK: - Data Arrangment Methods

extension ShoppingListViewModel {
    
    func filter(by isBought: Bool) {
        self.isBought = isBought
        self.getAllItems()
    }
}
