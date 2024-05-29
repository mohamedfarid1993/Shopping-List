//
//  RepositoryError.swift
//  Shopping List
//
//  Created by Mohamed Farid on 29/05/2024.
//

import Foundation

enum RepositoryError: Error {
    case fetchRequestError(description: String? = "Constructing fetch request failed!")
    case getAllItemsFailed(description: String)
    case getItemWithIdFailed(description: String)
    case addItemFailed(description: String)
    case updateItemFailed(description: String)
    case deleteItemFailed(description: String)
    case deleteAllItemsFailed(description: String)
}
