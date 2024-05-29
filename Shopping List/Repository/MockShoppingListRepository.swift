//
//  MockShoppingListRepository.swift
//  Shopping List
//
//  Created by Mohamed Farid on 29/05/2024.
//

import Foundation
import Combine

class MockShoppingListRepository: DataRepository {
    func getAll() -> AnyPublisher<[Item], Error> {
        let items = [
            Item(id: UUID(), name: "Apples", itemDescription: "Red Apples", quantity: 5, isBought: false),
            Item(id: UUID(), name: "Bananas", itemDescription: "Yellow Bananas", quantity: 7, isBought: true),
            Item(id: UUID(), name: "Test Item", itemDescription: "This is a test description.", quantity: 1, isBought: false)
        ]
        return Just(items)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func get(withId id: UUID) -> AnyPublisher<Item, Error> {
        let item = Item(id: id, name: "Apples", itemDescription: "Red Apples", quantity: 5, isBought: false)
        return Just(item)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func add(_ item: Item) -> AnyPublisher<Void, Error> {
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func update(_ item: Item) -> AnyPublisher<Void, Error> {
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func delete(withId id: UUID) -> AnyPublisher<Void, Error> {
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func deleteAll() -> AnyPublisher<Void, Error> {
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
