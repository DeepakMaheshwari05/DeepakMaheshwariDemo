# DeepakMaheshwariDemo

A native iOS application for displaying and managing stock portfolio holdings.

## Overview

This app displays a user's stock holdings with real-time portfolio analysis, including current value, total investment, profit/loss calculations, and individual stock performance metrics.

## Features

- Display list of stock holdings with detailed information
- Portfolio summary with key metrics:
  - Current value
  - Total investment
  - Today's profit & loss
  - Overall profit & loss
- Expandable portfolio header to view detailed statistics
- Offline support with fallback JSON data
- Clean MVVM architecture

## Architecture

The project follows the MVVM (Model-View-ViewModel) pattern:

- **Models**: Data structures (`HoldingModel`)
- **Views**: UI components (`HoldingTableViewCell`, `PortfolioSummaryHeaderView`)
- **ViewModels**: Business logic (`HoldingsViewModel`)
- **Controllers**: View controllers (`HoldingsViewController`)
- **Services**: Network and data services (`NetworkManager`, `HoldingsService`)

## Project Structure

```
DeepakMaheshwariDemo/
├── Constants/          # App-wide constants
├── Controllers/        # View controllers
├── Extensions/         # Swift extensions
├── Models/            # Data models
├── Resources/         # JSON files and other resources
├── Services/          # Networking and data services
├── ViewModels/        # MVVM view models
└── Views/             # Custom UI components
```

## Requirements

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## Installation

1. Clone the repository
2. Open `DeepakMaheshwariDemo.xcodeproj` in Xcode
3. Build and run the project (⌘ + R)

## Testing

The project includes unit tests and UI tests:

- **Unit Tests**: `DeepakMaheshwariDemoTests/`
- **UI Tests**: `DeepakMaheshwariDemoUITests/`

Run tests using ⌘ + U in Xcode.

## License

Copyright © 2025. All rights reserved.
