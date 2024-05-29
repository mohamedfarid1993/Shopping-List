//
//  ShoppingListManager.swift
//  Shopping List
//
//  Created by Mohamed Farid on 29/05/2024.
//

import SwiftData

protocol DataStore {
    associatedtype T

    func getAll() throws -> [T]
    func get(withId id: String) throws -> T?
    func add(_ item: T) throws
    func update(_ item: T) throws
    func delete(withId id: String) throws
}

struct ShoppingListManager {
    let dataStore: DataStore<Item>

    init(dataStore: DataStore<Item>) {
        self.dataStore = dataStore
    }

    func getAllItems() throws -> [Item] {
        return try dataStore.getAll()
    }

    func addItem(_ item: Item) throws {
        try dataStore.add(item)
    }

    func updateItem(_ item: Item) throws {
        try dataStore.update(item)
    }

    func deleteItem(withId id: String) throws {
        try dataStore.delete(withId: id)
    }
}
