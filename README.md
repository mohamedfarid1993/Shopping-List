# Shopping List App

This is a simple iOS application for managing your shopping list. Users can add, edit, delete items, mark items as bought/not bought, and search for items.

## Important Notes

- For data persistence, the app uses Swift Data framework. However, to comply with the task requirements, the Swift Data implementation has been placed on a separate branch named "swift-data". Please review this branch for the Swift Data integration. The main branch contains the solution that adheres to the specified requirements.
- I tried to simplify the solution as much as possible to be easy for review specially with SwiftData solution.

## Features

- **Add Items**: Users can add new items to the shopping list using the add button on the top left.
- **Edit Items**: Users can edit existing items in the shopping list by selecting an item and edit it in the edit item view.
- **Delete Items**: Users can delete items from the shopping list by either swiping left or using edit button on the top left.
- **Mark as Bought**: Users can mark items as bought, indicating that they have been purchased.
- **Mark as Not Bought**: Users can mark items as not bought, indicating that they have not been purchased yet.
- **Switch Between Bought/Not Bought**: Users can switch between bought/not bought items, using the Bought Items toggle.
- **Search**: Users can search for items in the shopping list based on their names/descriptions.
- **Sort Ascedingly/Desendingly**: Users can sort items ascendingly/descendingly based on the items quantites.

## Tests
- **UI Tests**: Adding an item and searching for it simple test is adding for both CoreData(main branch) and SwiftUI(swift-data branch) 
- **Unit Tests**: Added tests for DataRepository & the app view models testable logic for only CoreData(main Branch)
- **Maunal Tests**: Manual Testing is conducted to make sure all requirements are met
- **Memory Leaks Tests**: Memory leaks checks using Instruments(main branch) with zero memory leaks

## Enhancements To Be Added

- **User Experience**
- **iPad & Landscape Designs**
- **Localizable Text**
- **Error Handling**

## Technologies Used

- **SwiftUI**: The user interface is built using SwiftUI.
- **Core Data**: Data persistence is handled using Core Data in main Branch.
- **Swift Data**: Data persistence is handled using Core Data in swift-data Branch.

## Screenshots

<img src="https://github.com/mohamedfarid1993/Shopping-List/assets/37486139/ec5cbc73-aaa9-4eb6-b085-495caba9016c" alt="Screenshot 1" width="300">
<img src="https://github.com/mohamedfarid1993/Shopping-List/assets/37486139/e9dadecc-2749-4cb3-b877-1b1a7129adc6" alt="Screenshot 2" width="300">
<img src="https://github.com/mohamedfarid1993/Shopping-List/assets/37486139/01bad88d-b054-43db-b1f5-e95680642870" alt="Screenshot 3" width="300">
<img src="https://github.com/mohamedfarid1993/Shopping-List/assets/37486139/9c186b1e-ced0-4cbf-b865-6b7b951a2cbb" alt="Screenshot 4" width="300">
<img src="https://github.com/mohamedfarid1993/Shopping-List/assets/37486139/64c8710c-414d-4958-b3a0-7e2761db1141" alt="Screenshot 5" width="300">
<img src="https://github.com/mohamedfarid1993/Shopping-List/assets/37486139/99b4e940-a739-43f8-9218-5fd06f4001b1" alt="Screenshot 6" width="300">
<img src="https://github.com/mohamedfarid1993/Shopping-List/assets/37486139/55b6ecc6-c092-4a14-92ff-b6a057c62533" alt="Screenshot 7" width="300">
<img src="https://github.com/mohamedfarid1993/Shopping-List/assets/37486139/52282f2f-263b-4469-a728-c8c3a457ac71" alt="Screenshot 8" width="300">
<img src="https://github.com/mohamedfarid1993/Shopping-List/assets/37486139/a816a83a-ea20-44ee-8fdb-e0a695eb694b" alt="Screenshot 9" width="300">

## Getting Started

To get started with the project, follow these steps:

1. Clone the repository to your local machine:

```bash
git clone https://github.com/mohamedfarid1993/Shopping-List
