# ABNLocoPedia 

A native iOS app that fetches location data and integrates with the Wikipedia app through deep linking. 

Built as part of the ABN AMRO iOS Developer technical assessment.

---

## What This App Does

### Core Features
- **Fetches locations** from a remote API and displays them in a scrollable list
- **Search functionality** to filter locations by name (case-insensitive, real-time)
- **Deep linking** - tap any location to open it in the Wikipedia app at those exact coordinates
- **Custom location input** - manually enter a location name and coordinates to open in Wikipedia
- **Error handling** - shows friendly error messages if something goes wrong

### User Experience
When the app launches, it immediately fetches locations and shows them. You can search to narrow down the list, or tap the + button to add your own location with custom coordinates.

---

## Architecture

### Clean Architecture Approach

Chose Clean Architecture because it keeps different concerns separated. The business logic lives in one place, the data fetching lives in another, and the UI is completely separate. This makes the code easier to test and change later.

**The layers:**
- **Domain** - The core business rules and entities. No dependencies on anything else.
- **Data** - Handles fetching from the API and converting JSON to our models.
- **Presentation** - SwiftUI views and the ViewModel that manages UI state.
- **Core** - Shared services like the deep linking logic.

### Scalability
If tomorrow the API changes format, I only touch the Data layer. If we need a different UI, the business logic stays untouched. If we want to add a database, we just create a new repository implementation.

---

## Project Structure

| Layer | Component | File | Responsibility |
|-------|-----------|------|----------------|
| **Domain** | Entities | `Location.swift` | Business object with validation |
| | Repositories | `LocationRepository.swift` | Data access protocol |
| | Use Cases | `FetchLocationsUseCase.swift` | Filter valid locations |
| **Data** | Models | `LocationDTO.swift` | API response → Domain entity |
| | Network | `NetworkService.swift` | HTTP client (URLSession + Combine) |
| | Repository Impl | `LocationRepositoryImpl.swift` | Fetch data from API |
| **Presentation** | Views | `LocationsListView.swift` | SwiftUI UI |
| | ViewModels | `LocationsListViewModel.swift` | State management (MVVM) |
| | Models | `LocationsViewState.swift` | UI state enum |
| **Core** | Services | `DeepLinkService.swift` | Wikipedia deep linking |
| | Services | `DeepLinkConfigurations.swift` | URL configuration |
| | DI | `DIContainer.swift` | Dependency wiring |

---

## Technical Approach

### 1. MVVM with SwiftUI
I used the **Model-View-ViewModel** pattern because it's the natural fit for SwiftUI. The ViewModel holds the presentation logic and state, while the View just renders based on that state.

### 2. Combine for Reactive Updates
The app uses **Combine** for handling async operations. When locations are fetched, the ViewModel updates its state, and SwiftUI automatically redraws. This reactive approach means less manual UI updating and fewer bugs.

### 3. Explicit State Management
Instead of having multiple boolean flags like `isLoading`, `hasError`, `isEmpty`, I use a single `LocationsViewState` enum:
```swift
enum LocationsViewState {
    case idle
    case loading
    case loaded([Location])
    case error(String)
}
```

This prevents conflicting states (like "loading AND error at the same time") and makes the UI logic crystal clear.

### 4. Protocol-Based Design (Dependency Inversion)
Every major component depends on a protocol, not a concrete implementation:
- ViewModel depends on `FetchLocationsUseCaseProtocol`
- Use Case depends on `LocationRepository` protocol
- Repository depends on `NetworkServiceProtocol`

This makes testing easy. I can inject mock objects in tests without changing any production code.

### 5. No Strings laterals
The deep link configuration is centralized in `DeepLinkConfigurations`. No URLs are hardcoded throughout the app. If Wikipedia changes their URL scheme, I update one file.

### 6. No Third-Party Dependencies
No packages or third-party frameworks used, since it's an assignment with a single focused task.

---

## How Data Flows
```
1. User opens app —>
2. LocationsListView appears —>
3. ViewModel.loadLocations() called —>
4. FetchLocationsUseCase.execute() —>  
5. LocationRepository.fetchLocations() —>
6. NetworkService fetches JSON from API —>
7. JSON decoded to LocationDTO —>
8. DTO converted to Location (Domain entity) —>
9. Use Case filters out invalid locations —>
10. ViewModel updates state to .loaded([Location]) —>
11. SwiftUI automatically redraws the view
```

**If there's an error at any step**, it bubbles up through Combine, gets caught by the ViewModel, and state becomes `.error(message)`. The UI shows an error view with a retry button.

---

## Running the Project

### Requirements
- Xcode 15.0+
- iOS 16.0+
- Swift 5.9+

### Setup
1. Clone the repository
```bash
git clone https://github.com/Josevin-Johny/ABNLocoPedia.git
cd ABNLocoPedia
```

2. Open in Xcode
```bash
open ABNLocoPedia.xcodeproj
```

3. Run (⌘+R)

---

## Testing

### Test Coverage
I focused on testing the **business logic** rather than chasing 100% coverage:

**Domain Layer (9 tests)**
- Location validation (coordinates in range)
- Boundary value testing
- Entity equality

**Data Layer (4 tests)**
- DTO to domain conversion
- JSON decoding
- Handling optional fields

**Use Case Layer (3 tests)**
- Filtering invalid locations
- Error propagation

**Presentation Layer (6 tests)**
- State transitions (idle → loading → loaded)
- Search filtering
- Custom location validation
- Service integration

**Core Layer (4 tests)**
- Deep link URL creation
- Coordinate encoding

**Total: 26 tests**

### Running Tests
```bash
# In Xcode
⌘+U
```

---

## Future Improvements

### Can scale to:
1. **Geocoding service** - Fetch coordinates from location name
2. **Map view** - Show locations on a map using MapKit
3. **Location details** - Show Wikipedia summary in-app instead of just deep linking
4. **Favorites** - Let users save favorite locations
5. **Localization** - Support multiple languages

### Technical Debt:
- The ViewModel has both presentation logic and navigation (opening URLs). In a larger app, I'd extract navigation to a Coordinator/Router.

---

## Key Principles Applied

### SOLID Principles
- **Single Responsibility**: Each class has one job (ViewModel manages state, UseCase applies business rules, Repository fetches data)
- **Dependency Inversion**: High-level code depends on abstractions (protocols), not concrete implementations

### Clean Code
- Separation of concerns
- Meaningful names
- Small, focused functions

---

## API Reference

### Endpoint
```
GET https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json
```

### Response Format
```json
{
  "locations": [
    {
      "name": "Amsterdam",
      "lat": 52.3547498,
      "long": 4.8339215
    }
  ]
}
```

---

## Deep Linking

The app uses the Wikipedia app's custom URL scheme:
```
wikipedia://places?lat={latitude}&lon={longitude}
```

**Example:**
```
wikipedia://places?lat=52.3676&lon=4.9041
```

---

## Known Limitations

1. **No Wikipedia fallback**: If Wikipedia app isn't installed, nothing happens. Could add Safari fallback.
2. **Limited validation**: Doesn't check if coordinates actually point to a real place.

---

## Contact

**Josevin Johny**  
josevin.nl1988@gmail.com
