# AllEvents iOS App
![image](https://github.com/user-attachments/assets/3ddd42bf-60b0-4bb4-804a-0526b0c68478)

The idea is to create an application that has the goal of connecting people who want to play board games/sports/gaming based on location and distance.

AllEvents is an iOS application that allows exactly that.

Users can:
1. Grant location access.
2. Register or log in.
3. View a list of nearby events with search and filter options.
4. See event details, participants, and location on a map.
5. Share and confirm attendance at events.
6. Create new events with participant details, descriptions, and location pins.
7. View their upcoming events organized by date.


## Features
Here’s a structured outline of your app idea:

- **First Screen**: Request location permission from the user.
- **Registration/Login**: User authentication process.
- **Event Listing Screen**:
  - Display events sorted by distance.
  - Include search functionality and filters by category.
- **Event Details**:
  - Show event details, participant count, and list of participants.
  - Display event location on a map.
  - Options to share the event via messages or email.
  - Ability to confirm attendance.
- **Create Event**:
  - User can create an event with participant count, description, and category selection.
  - Map integration for pinning event location.
- **User's Events Screen**: Display events the user is attending, sorted by date.

## Firebase Integration

This app uses Firebase for the following functionalities:

- Firebase Auth to manage users
- Backup and transfer data between users with Firebase – Storage/Realtime DB.
- Firebase Images upload 


### Authentication

Firebase Authentication is used for user registration and login.

### Realtime Database

Firebase Realtime Database is used to store user data, including events and users.

### Storage

Firebase Storage is used to store user profile pictures.


## Shared Preferences

Shared Preferences are used to store user data locally on the device, providing a faster way to access user information without always querying the database.

## Animation

Lottie is used for the Animation of the app.

## Project Structure
![image](https://github.com/user-attachments/assets/ea5058cc-d758-4288-afab-04c1f1c2a5bb)

## Configuration

To configure the project, you need to set up Firebase:

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Create a new project.
3. Add an iOS app to your Firebase project.
4. Download the `GoogleService-Info.plist` file.
5. Replace the existing `GoogleService-Info.plist` file in the project with the new one.

## Usage

1. Open the project in Xcode.
2. Build and run the project on a simulator or a physical device.

## Code Overview
Here’s a structured list of the extensions we've created so it will be easy for us to perform certain actions:

- **String+Email**: 
  - Extension for email validation in `String`.

- **UIView+FirstResponder**: 
  - Variable to identify the currently focused component.

- **UIImageView+LoadFromUrl**: 
  - Loads images from a URL without blocking the main thread.

- **UIViewController+Alert**: 
  - Allows any view controller to display an alert with a custom message.

- **UIViewController+Loading**: 
  - Provides the ability to show/hide a loading animation in any view controller.

- **AllEventScrollableBaseViewController**: 
  - A base class for forms in the app, automatically adjusts scrolling when the keyboard appears to ensure the focused `TextField` remains visible above the keyboard.

## Helper Classes Overview:

- **ShareManager**: Manages sharing functionality, opening an AlertController for sharing events.
- **NavigationManager**: Handles navigation by opening navigation apps (e.g., Maps, Google Maps, Waze) to the selected event location.
- **SigninManager**: Responsible for API calls related to sign-in and sign-up processes.
- **EventsManager**: Manages event-related API calls, including attending, unattending, retrieving events, and creating new events.

- **Add Event Button**:
  - Located on the top right.
  - Opens a form with necessary fields and a map.
  - Clicking the map opens a full-screen view for address search or pin placement.
  - The map interaction returns a point and address.
  - The form includes validation.
  - After form submission, an event is created, and the user is added as a participant.

- **Event Details Screen**:
  - Displays event information and a map.
  - **Share Button**: Opens an ActivityController for sharing the event via available apps.
  - **Navigation Button**: Offers navigation options via Maps/Google Maps/Waze.
  - **RSVP Button**: 
    - If not registered: "I'm In" button registers the user.
    - If registered: "I'm Out" button cancels the registration.


## Video Demonstration

For a detailed video demonstration:

https://github.com/user-attachments/assets/65a05551-4c78-4257-9ec4-13fcd154a2df


## License
Copyright (c) 2024 Yarin Manoah | Amir Monayer
