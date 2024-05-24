****XKCD Comic Viewer****

**Description**

This is a simple XKCD comic viewer app for iOS, created as an MVP to showcase core functionalities such as browsing comics, viewing comic details, searching for comics, fetching comic explanations, favoriting comics, and sharing comics. The app is built using Swift and SwiftUI, with network operations handled via URLSession and HTML parsing via SwiftSoup.

**Features**

- Browse through XKCD comics
- View comic details including the title, image, alt text, and explanation
- Search for comics by their number or text
- Favorite comics for offline viewing
- Share comics via the system share sheet
- Pagination for loading more comics

**Thought process**

1) Identify core features: The primary features selected for the MVP are browsing comics, viewing details, searching, favoriting, and sharing.
2) Architecture design: Used MVVM (Model-View-ViewModel) for a clear separation of concerns.
3) Networking: Utilized URLSession for network requests and SwiftSoup for parsing HTML.
4) User interface: Designed with SwiftUI for a clean and responsive UI.
5) State management: Leveraged @Published and @State for state management in the app.

**Project structure**

<img width="237" alt="Skjermbilde 2024-05-24 kl  16 09 32" src="https://github.com/M-imo/xkcdViewer/assets/97694145/b19445e1-35c7-45dd-910f-d102c0be8774">



**Project architecture**

The project follows the MVVM architecture: 

+ Model: Represents the data (Comic.swift).
+ ViewModel: Manages the data for the views and handles business logic (ComicViewModel.swift).
+ View: SwiftUI views that display the UI and bind to ViewModel properties (ComicsListView.swift, ComicDetailView.swift).

**Coding practices and conventions**

Consistent Naming Conventions:
* Used camelCase for variables and functions, PascalCase for types.
* Frequent use of comments: Added comments to explain the purpose of classes, functions, and complex logic.
* Modular code: Separated concerns into different files and folders (e.g., Networking, Models, ViewModels, Views).

**Lint warnings and code smells**

The project is free of lint warnings and code smells. Proper error handling is in place, and unnecessary code duplication has been avoided.

**Unit & integration tests**

To keep the MVP simple and focus on core functionalities, unit tests and integration tests are not included in this version. However, they can be added as follows:

* Unit tests: Test the ViewModel logic and networking functions.
* Integration tests: Test the full flow from fetching data to displaying it in the UI.

**VCS history**

The VCS history includes multiple commits, each representing a significant step in the development process, such as setting up the project, implementing features, and refining the codebase.

**Notable points**
* Pagination: Implemented to load more comics as the user scrolls.
* Error handling: Network errors and data parsing errors are handled gracefully.
* State management: Effective use of Swift's state management with @Published and @State.
