# AllEvents iOS App
![image](https://github.com/user-attachments/assets/3ddd42bf-60b0-4bb4-804a-0526b0c68478)

AllEvents is an iOS application that allows connecting people who want to play board games, sports, or video games based on location and distance.
Users can:
1. Grant location access.
2. Register or log in.
3. View a list of nearby events with search and filter options.
4. See event details, participants, and location on a map.
5. Share and confirm attendance at events.
6. Create new events with participant details, descriptions, and location pins.
7. View their upcoming events organized by date.


## Features

The idea is to create an application that has the goal of connecting people who want to play board games/sports/gaming based on location and distance.
On the first screen, we will ask the user for permission to receive his location.
Then registration/login
When the user connects, he is shown a list with all the events that exist, arranged according to the distance from him.
 on the same screen there will be a search + filters by category.
By clicking on the event, the user will be shown:
	- the details of the event.
	- number of participants.
	- who is participating.
	- the location of the event on a map.
	-it will also be possible to share the event in messages | Email and of course the possibility to confirm his 	arrival at the event.
In addition, the user will be able to create an event himself on a dedicated screen, where he will enter the number of participants, a general description and a category selection, as part of the form a map will be opened to the user in which he will pin the location of the event.
Another screen the user will have is the events he attends arranged by date.

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

## Video Demonstration

For a detailed video demonstration:

https://github.com/user-attachments/assets/65a05551-4c78-4257-9ec4-13fcd154a2df


## License
Copyright (c) 2024 Yarin Manoah | Amir Monayer
