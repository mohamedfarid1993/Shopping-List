//
//  ShoppingListViewModelTests.swift
//  Shopping ListTests
//
//  Created by Mohamed Farid on 29/05/2024.
//

import XCTest
import Combine
@testable import Shopping_List

final class ShoppingListViewModelTests: XCTestCase {

    // MARK: Properties
    
    var viewModel: ShoppingListViewModel!
    var repository: ShoppingListRepository!
    var cancellables: Set<AnyCancellable>!
    
    // MARK: Setup Methods
    
    override func setUpWithError() throws {
        self.repository = ShoppingListRepository(isTesting: true)
        self.cancellables = Set<AnyCancellable>()
        self.viewModel = ShoppingListViewModel(repo: self.repository)
    }
    
    override func tearDownWithError() throws {
        self.repository = nil
        self.cancellables = nil
        self.viewModel = nil
    }
}

// MARK: - Test Cases

extension ShoppingListViewModelTests {
    
    func testInitialLoad() {
        // All times should be not bought
        self.viewModel.handleFetchedData(getItems())
        
        for item in self.viewModel.filteredItems {
            XCTAssertFalse(item.isBought)
        }
    }
    
    func testLoadingBoughtItems() {
        let isBought = true
        
        self.viewModel.filter(by: isBought)
        self.viewModel.handleFetchedData(getItems(isBought: true))
        
        for item in self.viewModel.filteredItems {
            XCTAssertTrue(item.isBought)
        }
    }
    
    func testLoadingNotBoughtItems() {
        let isBought = false
        
        self.viewModel.filter(by: isBought)
        self.viewModel.handleFetchedData(getItems())
        
        for item in self.viewModel.filteredItems {
            XCTAssertFalse(item.isBought)
        }
    }
    
    func testSearchByName() {
        let firstItem = getItems()[0]
        self.viewModel.searchText = firstItem.name
        self.viewModel.search()
        
        self.viewModel.handleFetchedData(getItems())
        
        for item in self.viewModel.filteredItems {
            XCTAssertTrue(item.name == firstItem.name)
        }
    }
    
    func testSearchByDescription() {
        let firstItem = getItems()[0]
        self.viewModel.searchText = firstItem.itemDescription
        self.viewModel.search()
        
        self.viewModel.handleFetchedData(getItems())
        
        for item in self.viewModel.filteredItems {
            XCTAssertTrue(item.itemDescription == firstItem.itemDescription)
        }
    }
    
    func testSearchingWithItemNotAdded() {
        self.viewModel.searchText = "Nil"
        self.viewModel.search()
        
        self.viewModel.handleFetchedData(getItems())
        
        XCTAssertTrue(self.viewModel.filteredItems.isEmpty)
    }
    
    func testSortingAscendingly() {
        self.viewModel.sort(by: .ascending)
        
        self.viewModel.handleFetchedData(getItems())
        
        for index in 0..<self.viewModel.filteredItems.count - 1 {
            if self.viewModel.filteredItems[index].quantity > self.viewModel.filteredItems[index + 1].quantity {
                assertionFailure("Items are not sorted correctly")
            }
        }
    }
    
    func testSortingDescendingly() {
        self.viewModel.sort(by: .descending)
        
        self.viewModel.handleFetchedData(getItems())
        
        for index in 0..<self.viewModel.filteredItems.count - 1 {
            if self.viewModel.filteredItems[index].quantity < self.viewModel.filteredItems[index + 1].quantity {
                assertionFailure("Items are not sorted correctly")
            }
        }
    }
    
    func testsSortingAscendinglyWithBoughtFilterAndSearch() {
        let isBought = true
        let searchText = "Bottles" // Should get 4 items
        self.viewModel.sortOrder = .ascending
        self.viewModel.searchText = searchText
        self.viewModel.filter(by: isBought)
        
        self.viewModel.handleFetchedData(self.getItems(isBought: true))
        
        for (index, item) in self.viewModel.filteredItems.enumerated() {
            XCTAssertTrue(item.isBought)
            XCTAssertTrue(item.itemDescription == searchText)
            guard index < self.viewModel.filteredItems.count - 1 else { return }
            if self.viewModel.filteredItems[index].quantity > self.viewModel.filteredItems[index + 1].quantity {
                assertionFailure("Items are not sorted correctly")
            }
        }
    }
}

// MARK: - Helpers

extension ShoppingListViewModelTests {
    
    private func getItems(isBought: Bool = false) -> [Item] {
        [
            Item(name: "Milk", itemDescription: "Bottles", quantity: 4, isBought: isBought),
            Item(name: "Water", itemDescription: "Bottles", quantity: 2, isBought: isBought),
            Item(name: "Soda", itemDescription: "Bottles", quantity: 3, isBought: isBought),
            Item(name: "Almond Mild", itemDescription: "Bottles", quantity: 1, isBought: isBought),
            Item(name: "Choclate", itemDescription: "Bars", quantity: 5, isBought: isBought)
        ]
    }
}
