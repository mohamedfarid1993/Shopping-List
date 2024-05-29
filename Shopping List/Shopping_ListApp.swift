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
        var isTesting = false
        #if DEBUG
        if CommandLine.arguments.contains("enable-testing") {
            isTesting = true
        }
        #endif
        return ShoppingListRepository(isTesting: isTesting)
    }
    
    // MARK: Body
    
    var body: some Scene {
        WindowGroup {
            ShoppingListView(repo: dataReposirtory)
        }
    }
}
