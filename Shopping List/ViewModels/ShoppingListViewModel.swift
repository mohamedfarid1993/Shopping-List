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
    
    // MARK: Initializers
    
    init() {
        self.observeRepositoryUpdates()
        self.getAllItems()
    }
}

// MARK: - Data Management Methods

extension ShoppingListViewModel {
    
    private func observeRepositoryUpdates() {
        ShoppingListRepository.shared.objectWillChange
            .sink { [weak self] _ in
                self?.getAllItems()
            }
            .store(in: &self.cancellables)
    }
    
    func getAllItems() {
        ShoppingListRepository.shared.getAll()
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else { return }
                self?.errorMessage = error.localizedDescription
                self?.isShowingError = true
            } receiveValue: { [weak self] data in
                self?.items = data
            }
            .store(in: &self.cancellables)
    }
    
    func deleteItem(by index: IndexSet.Element) {
        ShoppingListRepository.shared.delete(withId: items[index].id)
            .sink { [weak self] completion in
                guard case let .failure(error) = completion else { return }
                self?.errorMessage = error.localizedDescription
                self?.isShowingError = true
            } receiveValue: { _ in }
            .store(in: &self.cancellables)
    }
}
