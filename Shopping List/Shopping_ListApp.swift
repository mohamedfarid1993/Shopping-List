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
        ShoppingListRepository() // Then enables us to pass a mock repo for previews & testing
    }
    
    // MARK: Body
    
    var body: some Scene {
        WindowGroup {
            ShoppingListView(repo: dataReposirtory)
        }
    }
}
