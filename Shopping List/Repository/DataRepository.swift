//
//  DataRepository.swift
//  Shopping List
//
//  Created by Mohamed Farid on 29/05/2024.
//

import Foundation
import Combine

protocol DataRepository: AnyObject, ObservableObject where Self.ObjectWillChangePublisher == ObservableObjectPublisher {
    func getAll() -> AnyPublisher<[Item], Error>
    func add(_ item: Item) -> AnyPublisher<Void, Error>
    func update(_ item: Item) -> AnyPublisher<Void, Error>
    func delete(withId id: UUID) -> AnyPublisher<Void, Error>
}
