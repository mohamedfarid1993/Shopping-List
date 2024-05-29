//
//  ShoppingListViewUITests.swift
//  ShoppingListViewUITests
//
//  Created by Mohamed Farid on 27/05/2024.
//

import XCTest

final class ShoppingListViewUITests: XCTestCase {
    
    // MARK: Setup Methods
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments =  ["enable-testing"]
        app.launch()
    }
}

// MARK: - Test Cases

extension ShoppingListViewUITests {
    
    func testAddNewItemAndSearchFunctionalities() throws {
        let app = XCUIApplication()
        
        // Tap the "Add Item" button
        let addItemButton = app.buttons["AddItemButton"]
        XCTAssertTrue(addItemButton.exists, "The 'Add Item' button should exist")
        addItemButton.tap()
        
        // Enter text into the Name field
        let nameTextField = app.textFields["NameTextField"]
        XCTAssertTrue(nameTextField.exists, "The Name text field should exist")
        nameTextField.tap()
        nameTextField.typeText("Test Item")
        
        // Enter text into the Description field
        let descriptionTextField = app.textFields["DescriptionTextField"]
        XCTAssertTrue(descriptionTextField.exists, "The Description text field should exist")
        descriptionTextField.tap()
        descriptionTextField.typeText("This is a test description.")
        
        // Adjust the quantity using the stepper
        let quantityStepper = app.steppers["QuantityStepper"]
        XCTAssertTrue(quantityStepper.exists, "The Quantity stepper should exist")
        quantityStepper.buttons["QuantityStepper-Increment"].tap()  // Increment the quantity by 1
        
        // Tap the Save button
        let saveButton = app.buttons["SaveButton"]
        XCTAssertTrue(saveButton.exists, "The Save button should exist")
        saveButton.tap()
        
        // Verify that the add item view is dismissed
        let addItemView = app.otherElements["AddItemView"]
        XCTAssertFalse(addItemView.exists, "The add item view should be dismissed after saving the new item")
        
        // Search for an item
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists, "The search field should exist")
        searchField.tap()
        searchField.typeText("Test Item")
        
        // Verify that an item does appear in the list
        let newItem = app.staticTexts["Test Item"]
        XCTAssertTrue(newItem.exists, "The new item should appear in the list after being added")
    }
}
