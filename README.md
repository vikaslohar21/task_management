# Task Management

A small Flutter task management app built for a Flutter/Dart technical assignment.

## Features

- Fetches tasks from JSONPlaceholder
- Search tasks by title
- Filter by All / Completed / Pending
- Add task with form validation
- Edit an existing task
- Delete task with confirmation
- Loading, empty and error states
- Pull-to-refresh
- GetX state management
- REST API integration with `http`

## Project structure

lib/
├── controllers/
│   └── task_controller.dart
├── models/
│   └── task.dart
├── screens/
│   ├── task_form_screen.dart
│   └── task_list_screen.dart
├── services/
│   └── api_service.dart
├── widgets/
│   ├── filter_bar.dart
│   └── task_card.dart
└── main.dart

## Setup

1. Install Flutter.
2. Clone/download the project.
3. Run:

bash Commands : 
- flutter pub get
- flutter run


For an Android APK:

bash: 
flutter build apk --release

## Flutter version

Developed with Flutter 3.47.2 / 3.13.2 .

## Packages

- `get` - state management and simple navigation/snackbars
- `http` - REST API calls

## API

JSONPlaceholder:

`https://jsonplaceholder.typicode.com/`

Endpoints used:

- GET `/todos`
- POST `/todos`
- PUT `/todos/{id}`
- DELETE `/todos/{id}`

## Assumptions / limitations

JSONPlaceholder is a fake REST API. POST, PUT and DELETE requests return successful mock responses but changes are not permanently stored on the server.

The assignment asks for a description field, while the `/todos` resource does not officially contain a description field. The app therefore keeps the description in the local application model. It is included in request data but should not be expected to survive a fresh GET from JSONPlaceholder.

## Git commits

commit history:

-Initial Flutter setup
-Added task model and API service files
-Updated main file
-Implemented task list and filter bar
-Implemented task form add/edit task
-Project Readme 
