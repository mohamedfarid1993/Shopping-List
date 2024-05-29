//
//  ShoppingListTests.swift
//  Shopping ListTests
//
//  Created by Mohamed Farid on 29/05/2024.
//

import XCTest
import Combine
import CoreData
@testable import Shopping_List

final class ShoppingListRepositoryTests: XCTestCase {
    
    // MARK: Properties
    
    var repository: ShoppingListRepository!
    var cancellables: Set<AnyCancellable>!
    
    // MARK: Setup Methods
    
    override func setUpWithError() throws {
        self.repository = ShoppingListRepository(isTesting: true)
        self.cancellables = Set<AnyCancellable>()
    }
    
    override func tearDownWithError() throws {
        self.repository = nil
        self.cancellables = nil
    }
}

// MARK: - Tessting Cases

extension ShoppingListRepositoryTests {
    
    func testAddItemSuccess() {
        let id = UUID()
        let item = Item(id: id, name: "Milk", itemDescription: "2 liters", quantity: 1, isBought: false)
        
        let expectation = self.expectation(description: "Item added")
        
        self.repository.add(item)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected to succeed, but failed")
                }
            }, receiveValue: {
                expectation.fulfill()
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 1, handler: nil) // To validate that adding items is returning success
    }
    
    func testGetAllItemsSuccess() {
        // Construct item
        let id = UUID()
        let name = "Milk"
        let itemDescription = "2 liters"
        let quantity = 1
        let isBought = false
        let item = Item(id: id, name: name, itemDescription: itemDescription, quantity: quantity, isBought: isBought)
        
        // Add item
        let addItemExpectation = self.expectation(description: "Item added")
        
        self.repository.add(item)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected to succeed, but failed")
                }
            }, receiveValue: {
                addItemExpectation.fulfill()
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 1, handler: nil) // Item added
        
        let expectation = self.expectation(description: "Items fetched")
        
        self.repository.getAll()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected to succeed, but failed")
                }
            }, receiveValue: { items in
                // validate item properties are equal to the item we created
                XCTAssertEqual(items[0].id, id)
                XCTAssertEqual(items[0].name, name)
                XCTAssertEqual(items[0].itemDescription, itemDescription)
                XCTAssertEqual(items[0].quantity, quantity)
                XCTAssertEqual(items[0].isBought, isBought)
                expectation.fulfill()
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 1, handler: nil) // Validate items are fetched and the item is the same one we added
    }
    
    func testUpdateItemSuccess() throws {
        // Construct item
        let id = UUID()
        let item = Item(id: id, name: "Milk", itemDescription: "2 liters", quantity: 1, isBought: false)
        
        // Add item
        let addItemExpectation = self.expectation(description: "Item added")
        
        self.repository.add(item)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected to succeed, but failed")
                }
            }, receiveValue: {
                addItemExpectation.fulfill()
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 2, handler: nil) // Item added
        
        // Construct updates
        let updatedName = "Almond Milk"
        let updatedItemDescription = "1 liter"
        let updatedQuantity = 2
        let updatedIsBought = true
        let updatedItem = Item(id: id, name: updatedName, itemDescription: updatedItemDescription, quantity: updatedQuantity, isBought: updatedIsBought)
        
        let expectation = self.expectation(description: "Item updated")
        
        self.repository.update(updatedItem)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected to succeed, but failed")
                }
            }, receiveValue: { updatedItem in
                expectation.fulfill()
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 10, handler: nil) // Validate updating item succeeded
        
        // Verify update
        let fetchExpectation = self.expectation(description: "Fetch updated item")
        
        self.repository.getAll()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected to succeed, but failed")
                }
            }, receiveValue: { items in
                // validate updated item properties are equal to the changes we made
                XCTAssertEqual(items[0].id, id)
                XCTAssertEqual(items[0].name, updatedName)
                XCTAssertEqual(items[0].itemDescription, updatedItemDescription)
                XCTAssertEqual(items[0].quantity, updatedQuantity)
                XCTAssertEqual(items[0].isBought, updatedIsBought)
                fetchExpectation.fulfill()
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 1, handler: nil) // Validate item updated correctly
    }
    
    func testDeleteItemSuccess() throws {
        let id = UUID()
        let item = Item(id: id, name: "Milk", itemDescription: "2 liters", quantity: 1, isBought: false)
        
        // Add item
        let addItemExpectation = self.expectation(description: "Item added")
        
        self.repository.add(item)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected to succeed, but failed")
                }
            }, receiveValue: {
                addItemExpectation.fulfill()
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 2, handler: nil) // Item added
        
        let expectation = self.expectation(description: "Item deleted")
        
        repository.delete(withId: id)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected to succeed, but failed")
                }
            }, receiveValue: {
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil) // Validate deleting item succeeded
        
        // Verify deletion
        let fetchExpectation = self.expectation(description: "Fetch after delete")
        
        self.repository.getAll()
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected to succeed, but failed")
                }
            }, receiveValue: { items in
                // validate items are empty
                XCTAssertTrue(items.isEmpty)
                fetchExpectation.fulfill()
            })
            .store(in: &self.cancellables)
        
        waitForExpectations(timeout: 1, handler: nil) // Validate item deleted correctly
    }
}
