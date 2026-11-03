# Simple Bank Account Manager

A Flutter application that manages bank accounts using SQLite local database storage.

## Experiment Objective

To develop a Flutter application that stores and retrieves bank account information using SQLite, displays account details, identifies zero-balance accounts, and calculates the total money in the bank.

## Technologies Used

- Flutter
- Dart
- SQLite
- sqflite
- path

## Features

1. **Add Account:** Enter an account holder's name and initial balance.
2. **SQLite Storage:** Store account information locally in an SQLite database.
3. **Display Accounts:** Retrieve and display all saved accounts.
4. **Low Balance Warning:** Display a red "Low Balance!" warning for accounts with zero balance.
5. **Total Balance:** Calculate and display the combined balance of all accounts.
6. **Data Persistence:** Preserve account information after closing and reopening the application.
7. **Input Validation:** Reject empty account names, invalid balances, and negative balances.

## Database Structure

**Database:** `bank_accounts.db`

**Table:** `accounts`

| Column | Data type | Description |
|---|---|---|
| id | INTEGER | Primary key, auto-increment |
| accountHolder | TEXT | Account holder's name |
| balance | REAL | Account balance |

## Application Screenshots

Add your Android emulator screenshot here.

## Testing and Verification

- Flutter static analysis: Passed.
- Automated widget tests: 4/4 passed.
- Android emulator execution: Successful.
- SQLite account insertion and retrieval: Verified.
- Total balance calculation: Verified.
- Zero-balance warning: Verified.
- Data persistence after application restart: Verified.

## How to Run

1. Clone the repository.
2. Navigate to the project directory.
3. Install dependencies:

```bash
flutter pub get
```

4. Connect an Android device or start an Android emulator.
5. Run the application:

```bash
flutter run
```

## Project Structure

```text
exercise_7_bank_account_manager/
├── lib/
│   ├── database_helper.dart
│   └── main.dart
├── test/
│   └── widget_test.dart
├── android/
├── pubspec.yaml
└── README.md
```

## Conclusion

The Simple Bank Account Manager successfully demonstrates SQLite integration in Flutter. Account information is stored locally, retrieved and displayed through the application interface. The application also performs balance calculations, validates user input, identifies zero-balance accounts, and maintains data persistence across application restarts.