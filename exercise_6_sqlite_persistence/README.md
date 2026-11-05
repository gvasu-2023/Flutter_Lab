@'
# Experiment 6 – SQLite Database Persistence

**Course:** 24CS2016 – Building Applications using Flutter

**Date:** 31-08-2026

## Aim

To develop a Flutter application that stores and retrieves bank account
information using an SQLite database.

## Description

The Simple Bank Account Manager demonstrates local database persistence
using SQLite.

Users can enter account holder details and initial balances.
The application stores the information in a local SQLite database,
retrieves saved accounts, and calculates the total balance.

## Technologies Used

- Flutter
- Dart
- SQLite
- sqflite
- sqflite_common_ffi_web
- path

## Features

1. Add bank accounts.
2. Store account information in SQLite.
3. Retrieve and display saved accounts.
4. Calculate the total balance.
5. Display a low-balance warning for zero-balance accounts.
6. Validate account holder names and balances.
7. Preserve stored records after application restart.

## Database Structure

Database: bank_accounts.db

Table: accounts

| Column | Data type | Description |
|---|---|---|
| id | INTEGER | Primary key, auto-increment |
| accountHolder | TEXT | Account holder name |
| balance | REAL | Account balance |

## Result

Successfully developed a Flutter application demonstrating
SQLite database creation, insertion, retrieval, and persistence.
'@ | Set-Content ".\README.md" -Encoding utf8