# Cook That Thing - Visit [This Link](https://drive.google.com/drive/folders/11sJTFwHTTki_BoMdnOgbCuqmDSnV7dv8?usp=sharing) to see how the app run on a device

## Project Overview

This Flutter and Firebase application is designed to create a vibrant social platform for sharing and discovering recipes. Built with Clean Architecture principles, it ensures a scalable and maintainable codebase, focusing on user engagement through various interactive features.

## Key Features

### User Authentication

- Secure login and registration process.
- Password recovery and email verification functionalities.

### Recipe Management

- Users can add, edit, and delete their own recipes.
- Recipes can be tagged with ingredients, cuisine type, and difficulty level for better discoverability.

### Interaction Features

- Follow other users to stay updated with their latest recipes.
- Like and comment on recipes to engage with the community.
- Favorite recipes for quick access later.
- Rate recipes to contribute to the overall rating system.

### Notifications

- Receive notifications for likes, comments, follows, and direct messages to stay engaged with the community.

### Search and Discovery

- Advanced search capabilities to find recipes based on tags, ingredients, and dietary restrictions.
- Explore popular recipes and chefs to discover new favorites.

### User Grading System

- Based on the ratings received from other users, users can grade others, fostering a competitive yet supportive environment.

## Getting Started

### Prerequisites

- Ensure you have Flutter and Dart development tools installed on your system. Refer to the official Flutter documentation for detailed setup instructions: [Flutter Setup Guide](https://docs.flutter.dev/get-started/install)
- Create a Firebase project and configure it within your Flutter app following Firebase's guidance: [Firebase Console](https://console.firebase.google.com/)

### Clone the Repository

Use Git to clone the Social Recipe App repository to your local machine.

### Set up Firebase (if applicable)

Replace placeholder values in the project's code with your Firebase project credentials (API key, project ID, etc.). Adhere to Firebase security best practices to protect sensitive data.

### Run the App

Navigate to the project directory in your terminal and execute `flutter run` to launch the app on a connected device or emulator.

## Project Structure (Clean Architecture)

The project structure is organized according to Clean Architecture principles, ensuring a clear separation of concerns and enhanced maintainability. The architecture is divided into three main layers:

### Data Layer

Manages data access logic, interfacing with Firebase for data persistence and retrieval.

### Domain Layer

Contains the core business logic of the application, abstracting away UI and data storage concerns. Defines models and operations for managing recipes and user interactions.

### Presentation Layer

Responsible for UI components and user interactions. Communicates with the domain layer to display data and handle user inputs.

### Additional Considerations

- **Error Handling:** Implement comprehensive error handling to deal with potential issues gracefully.
- **Documentation:** Keep the codebase well-documented with clear comments to aid understanding and facilitate future modifications.

Contributions are welcome To contribute:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes, ensuring adherence to coding conventions and quality standards.
4. Submit a pull request for review and potential inclusion in the project.
