//
//  ShoppingListManager.swift
//  Shopping List
//
//  Created by Mohamed Farid on 29/05/2024.
//

import CoreData

class ShoppingListRepository: ObservableObject {
    
    // MARK: Properties
    
    typealias T = Item
    
    public static var shared = ShoppingListRepository()
    private let container: NSPersistentContainer
    private var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    // MARK: Initializers
    
    private init() {
        container = NSPersistentContainer(name: "ShoppingList")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }
}

// MARK: - Data Repository

extension ShoppingListRepository: DataRepository {
    
    func getAll() -> [Item] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemEntity")
        do {
            guard let result = try context.fetch(fetchRequest) as? [NSManagedObject] else { return [] }
            return result.map { $0.toItem() }
        } catch {
            print("Error fetching items: \(error)")
            return []
        }
    }
    
    func get(withId id: UUID) -> Item? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemEntity")
        do {
            fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
            guard let itemEntities = try context.fetch(fetchRequest) as? [NSManagedObject] else { return nil }
            if let itemEntity = itemEntities.first {
                return itemEntity.toItem()
            } else {
                return nil
            }
        } catch {
            print("Error fetching item: \(error)")
            return nil
        }
    }
    
    func add(_ item: Item) {
        guard let entity = NSEntityDescription.entity(forEntityName: "ItemEntity", in: context) else { return }
        let object = NSManagedObject(entity: entity, insertInto: context)
        object.setValue(item.id, forKey: "id")
        object.setValue(item.name, forKey: "name")
        object.setValue(item.itemDescription, forKey: "item_description")
        object.setValue(item.quantity, forKey: "quantity")
        object.setValue(item.isBought, forKey: "is_bought")
        
        try? context.save()
        self.objectWillChange.send()
    }
    
    func update(_ item: Item) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %@", item.id.uuidString)
        
        do {
            let itemEntities = try context.fetch(fetchRequest)
            if let itemEntity = itemEntities.first as? NSManagedObject {
                itemEntity.setValue(item.id, forKey: "id")
                itemEntity.setValue(item.name, forKey: "name")
                itemEntity.setValue(item.itemDescription, forKey: "item_description")
                itemEntity.setValue(item.quantity, forKey: "quantity")
                itemEntity.setValue(item.isBought, forKey: "is_bought")
                
                try? context.save()
                self.objectWillChange.send()
            }
        } catch {
            print("Error updating item: \(error)")
        }
    }
    
    func delete(withId id: UUID) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemEntity")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
        
        do {
            let itemEntities = try context.fetch(fetchRequest)
            if let itemEntity = itemEntities.first as? NSManagedObject {
                context.delete(itemEntity)
                try context.save()
                self.objectWillChange.send()
            }
        } catch {
            print("Error deleting item: \(error)")
        }
    }
    
    func deleteAll() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try context.save()
            self.objectWillChange.send()
        } catch {
            print("Error deleting all items: \(error)")
        }
    }
}
