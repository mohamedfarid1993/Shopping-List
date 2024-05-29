//
//  ShoppingListManager.swift
//  Shopping List
//
//  Created by Mohamed Farid on 29/05/2024.
//

import CoreData
import Combine

class ShoppingListRepository: ObservableObject {
    
    // MARK: Properties
        
    private let container: NSPersistentContainer
    private var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    // MARK: Initializers
    
    init(isTesting: Bool = false) {
        container = NSPersistentContainer(name: "ShoppingList")
        if isTesting { // To save in memory during testing to always start fresh and not affect app data
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }
}

// MARK: - Data Repository Methods

extension ShoppingListRepository: DataRepository {
    
    func getAll() -> AnyPublisher<[Item], Error> {
        Future<[Item], Error> { [weak self] promise in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemEntity")
            do {
                guard let result = try self?.context.fetch(fetchRequest) as? [NSManagedObject]
                else { promise(.failure(RepositoryError.fetchRequestError(description: nil))); return }
                promise(.success(result.map { $0.toItem() }))
            } catch {
                promise(.failure(RepositoryError.getAllItemsFailed(description: error.localizedDescription)))
            }
        }.eraseToAnyPublisher()
    }
    
    func add(_ item: Item) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            guard
                let context = self?.context,
                let entity = NSEntityDescription.entity(forEntityName: "ItemEntity", in: context)
            else { return }
            let object = NSManagedObject(entity: entity, insertInto: context)
            object.setValue(item.id, forKey: "id")
            object.setValue(item.name, forKey: "name")
            object.setValue(item.itemDescription, forKey: "item_description")
            object.setValue(item.quantity, forKey: "quantity")
            object.setValue(item.isBought, forKey: "is_bought")
            do {
                try context.save()
                self?.objectWillChange.send()
                promise(.success(Void()))
            } catch {
                promise(.failure(RepositoryError.addItemFailed(description: error.localizedDescription)))
            }
        }.eraseToAnyPublisher()
    }
    
    func update(_ item: Item) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemEntity")
            fetchRequest.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
            do {
                let itemEntities = try self?.context.fetch(fetchRequest)
                if let itemEntity = itemEntities?.first as? NSManagedObject {
                    itemEntity.setValue(item.id, forKey: "id")
                    itemEntity.setValue(item.name, forKey: "name")
                    itemEntity.setValue(item.itemDescription, forKey: "item_description")
                    itemEntity.setValue(item.quantity, forKey: "quantity")
                    itemEntity.setValue(item.isBought, forKey: "is_bought")
                    
                    try self?.context.save()
                    self?.objectWillChange.send()
                    promise(.success(Void()))
                }
            } catch {
                promise(.failure(RepositoryError.updateItemFailed(description: error.localizedDescription)))
            }
        }.eraseToAnyPublisher()
    }
    
    func delete(withId id: UUID) -> AnyPublisher<Void, Error> {
        Future<Void, Error> { [weak self] promise in
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemEntity")
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            do {
                let itemEntities = try self?.context.fetch(fetchRequest)
                if let itemEntity = itemEntities?.first as? NSManagedObject {
                    self?.context.delete(itemEntity)
                    try self?.context.save()
                    self?.objectWillChange.send()
                    promise(.success(Void()))
                }
            } catch {
                promise(.failure(RepositoryError.deleteItemFailed(description: error.localizedDescription)))
            }
        }.eraseToAnyPublisher()
    }
}
