# Exercise 9 – Update Book Copies using Google Firestore

## Overview

This Flutter application demonstrates how to retrieve and update existing book information stored in Google Cloud Firestore. Users can search for a book using its title, view its details, and update the number of available copies.

## Objective

To develop a Flutter application that updates book information in Google Firestore based on user input and displays the updated information.

## Technologies Used

- Flutter
- Dart
- Firebase Core
- Cloud Firestore
- Visual Studio Code

## Features

- Search existing books by title.
- Retrieve book details from Firestore.
- Display book title, author, and available copies.
- Update the available copies of a selected book.
- Display the updated information immediately.
- Validate user input and handle unsuccessful searches.

## Firestore Database

**Collection:** `books`

Each document contains:

| Field | Data type | Description |
|---|---|---|
| id | String | Book identifier |
| title | String | Book title |
| author | String | Author name |
| copies | Number | Available copies |

Sample records were created manually in the Firebase Console before using the Flutter application.

## Project Structure

```text
lib/
├── main.dart
├── firebase_options.dart
├── screens/
│   └── book_screen.dart
└── services/
    └── firestore_service.dart
```

## How to Run

1. Install Flutter and configure the development environment.
2. Clone this repository.
3. Open the `exercise_9_update_book_copies` folder.
4. Install dependencies:

   ```bash
   flutter pub get
   ```

5. Configure Firebase for your own Firebase project using FlutterFire CLI.
6. Create a Firestore collection named `books` and add book documents with the required fields.
7. Run the application:

   ```bash
   flutter run -d chrome
   ```

## Application Workflow

1. Enter the exact title of an existing book.
2. Select **Search Book**.
3. View the retrieved book details.
4. Enter the new number of available copies.
5. Select **Update Copies**.
6. Verify the updated value in Firestore.

## Verification

The application was tested with a sample book:

- Book: Flutter Programming
- Author: John Smith
- Original copies: 15
- Updated copies: 25

The update was verified in the Firestore database.

## Academic Note

The Firestore security rules used during the demonstration are temporary rules for sample academic records. They are not intended for production deployment. Configure appropriate authentication and authorization before using this application with real data.