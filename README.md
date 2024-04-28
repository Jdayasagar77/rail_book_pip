# rail_book_pip

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app] (https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples] (https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

This document outlines the functionalities and setup instructions for the Flutter mobile application designed for booking train tickets through IRCTC.

## Features:
* User Registration: Sign up with details like name, date of birth, email, phone number, profile picture [optional], and password. Includes validation for each field.
* User Login: Login using registered email and password. Login button becomes active only after entering valid details.
* Bottom Navigation Bar: Provides easy access to Home, My Account, and My Transactions sections.
* Home Screen:
   * Book Train: Search for trains with functionalities like:
      * Autocomplete dropdown for source and destination stations.
      * Selectable travel class [AC, SL, 2S].
      * Departure date selection using a date picker.
      * Quota selection [GEN, etc.].
      * Search button to retrieve trains based on chosen criteria.
      * Displays a list of trains with details like price, availability, and non-availability.
      * User can select a train, add passenger details (name, age, class), and proceed to payment.
      * Payment button redirects to a payment page with a 7-minute timer for successful transaction.
      * Upon successful payment, navigates to the Order Success page.
* My Account Tab:
   * Displays profile icon with user name and email ID.
   * My Profile: Allows editing user information like name, date of birth, email, mobile number, and address.
   * Change Password: Redirects to a screen for changing the user's password.
   * Logout button to sign out of the application.

## Technical Stack:
* Programming Language: Dart
* Framework: Flutter
* Database: Firebase Firestore
* API: IRCTC API (https://rapidapi.com/IRCTCAPI/api/irctc1)

## Setup Instructions:
1. Prerequisites:
   * Ensure you have Flutter and Dart installed on your development machine (https://docs.flutter.dev/get-started/install).
   * Create a Firebase project and set up Firestore database (https://firebase.google.com/docs/projects/api/workflow_set-up-and-manage-project).
   * Obtain an API key from the provided IRCTC API source.
2. Project Setup:
   * Clone this Flutter project repository (if applicable).
   * Install dependencies using flutter pub get.
3. Configuration:
   * Replace placeholder values in env files with your Firebase project credentials and IRCTC API key.

## Additional Notes:
* The application prioritizes proper code style and maintainability.
* UI design strives for pixel-perfect rendering.

## Disclaimer:
This document serves as a general guideline for the application's functionalities. The actual implementation details might vary depending on the specific codebase.