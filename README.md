# LeagueChallenge

## Overview

LeagueChallenge is an iOS application made using Swift and SwiftUI. It allows users to authenticate and explore posts associated with each user. The app follows the MVVM architecture pattern to ensure a clear separation of concerns, maintainable and testable code structure.

## Features

- **User Authentication**: Users can log in with credentials or continue as guests.
- **User List**: Display a list of users fetched from the API.
- **User Details**: View detailed information about a selected user.
- **Post Details**: Access detailed information about individual posts.

## Architecture

The project is structured based on the MVVM architecture pattern:

- **Model**: Defines the data structures. `User`, `LoginResponse` and `Post` represent the data models.
- **View**: Comprises SwiftUI views such as `UserInfoView` and `PostListView` that define the UI.
- **ViewModel**: Contains business logic and handles data manipulation. There are 3 view models named `AuthViewModel`, `UserViewModel`, and `PostViewModel`.

This architecture promotes a clear separation between the UI and business logic, enhancing testability and scalability.

## Folder Structure

The project is organized as follows:

- `Models/`: Contains data structures and model definitions.
- `Views/`: Contains SwiftUI view files.
- `ViewModels/`: Includes all view model classes managing the state and logic.
- `Network/`: Contains networking layer.
