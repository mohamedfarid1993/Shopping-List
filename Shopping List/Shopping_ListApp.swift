//
//  Shopping_ListApp.swift
//  Shopping List
//
//  Created by Mohamed Farid on 27/05/2024.
//

import SwiftUI
import SwiftData

@main
struct Shopping_ListApp: App {
    
    var dataReposirtory: any DataRepository {
        #if DEBUG
        if CommandLine.arguments.contains("enable-testing") {
            return MockShoppingListRepository()
        } else {
            return ShoppingListRepository()
        }
        #endif
    }
    
    // MARK: Body
    
    var body: some Scene {
        WindowGroup {
            ShoppingListView(repo: dataReposirtory)
        }
    }
}
