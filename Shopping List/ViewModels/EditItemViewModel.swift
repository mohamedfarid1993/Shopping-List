//
//  EditItemViewModel.swift
//  Shopping List
//
//  Created by Mohamed Farid on 29/05/2024.
//

import Foundation
import Combine

class EditItemViewModel: ObservableObject {
    
    // MARK: Properties
    
    private var cancellables: Set<AnyCancellable> = []
    private var repo: any DataRepository
    
    // MARK: Initializers
    
    init(repo: any DataRepository) {
        self.repo = repo
    }
}

// MARK: - Data Repository

extension EditItemViewModel {
    
    func update(_ item: Item) {
        self.repo.update(item)
            .sink { completion in
                guard case let .failure(error) = completion else { return }
                print("Error Updating Items Becuase: \(error.localizedDescription)")
            } receiveValue: { _ in }
            .store(in: &self.cancellables)
    }
}
