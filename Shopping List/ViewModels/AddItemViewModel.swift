//
//  AddItemViewModel.swift
//  Shopping List
//
//  Created by Mohamed Farid on 29/05/2024.
//

import Foundation
import Combine

class AddItemViewModel: ObservableObject {
    
    // MARK: Properties
    
    private var cancellables: Set<AnyCancellable> = []
    private var repo: any DataRepository
    
    // MARK: Initializers
    
    init(repo: any DataRepository) {
        self.repo = repo
    }
}


// MARK: - Data Repository

extension AddItemViewModel {
    
    func addItem(_ item: Item) {
        self.repo.add(item)
            .sink { completion in
                guard case let .failure(error) = completion else { return }
                print("Error Adding Items Becuase: \(error.localizedDescription)")
            } receiveValue: { _ in }
            .store(in: &self.cancellables)
    }
}
