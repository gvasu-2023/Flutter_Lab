# Experiment 3 – Working with Dynamic ListView

**Course:** 24CS2016 – Building Applications using Flutter  
**Date:** 03-08-2026

## Aim

To develop a Flutter application using Dynamic ListView to display,
add and remove student records dynamically.

## Description

This application demonstrates the use of ListView.builder
to generate list items dynamically from a collection of student records.

Users can enter student details, add records to the list,
and remove existing records.

The application updates the interface using StatefulWidget
and setState().

## Widgets and Concepts Used

- MaterialApp
- Scaffold
- AppBar
- StatefulWidget
- TextFormField
- Form and GlobalKey
- ListView.builder
- ListTile
- Card
- CircleAvatar
- IconButton
- setState()

## Application Features

1. Displays student records.
2. Adds new student records.
3. Validates input fields.
4. Prevents duplicate register numbers.
5. Deletes student records.
6. Updates the student count dynamically.

## Program Logic

1. Create a Student class to store student details.
2. Maintain student records in a List.
3. Use ListView.builder to generate list items.
4. Use setState() when adding or deleting records.
5. Validate student details before insertion.

## Result

The Student Record Manager was developed successfully
using Flutter Dynamic ListView. Student records can be
added and removed dynamically, and the interface updates
automatically.