//
//  DataRepository.swift
//  Shopping List
//
//  Created by Mohamed Farid on 29/05/2024.
//

import Foundation

protocol DataRepository {
    associatedtype T

    func getAll() -> [T]
    func get(withId id: UUID) -> T?
    func add(_ item: T)
    func update(_ item: T)
    func delete(withId id: UUID)
    func deleteAll()
}
