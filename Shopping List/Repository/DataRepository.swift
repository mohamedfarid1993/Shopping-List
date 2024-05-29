//
//  DataRepository.swift
//  Shopping List
//
//  Created by Mohamed Farid on 29/05/2024.
//

import Foundation
import Combine

protocol DataRepository {
    associatedtype T

    func getAll() -> AnyPublisher<[T], Error>
    func get(withId id: UUID) -> AnyPublisher<T, Error>
    func add(_ item: T) -> AnyPublisher<Void, Error>
    func update(_ item: T) -> AnyPublisher<Void, Error>
    func delete(withId id: UUID) -> AnyPublisher<Void, Error>
    func deleteAll() -> AnyPublisher<Void, Error>
}
