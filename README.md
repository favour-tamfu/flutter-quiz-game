#  Flutter Quiz Game

A dynamic and engaging quiz application built with Flutter that challenges users with questions across various categories and difficulty levels. The app features a clean user interface, timed quizzes, and local data persistence using an SQLite database.

---

## 📸 Screenshots

*(This is the most important section! Replace these placeholders with actual screenshots of your app. You can drag and drop images directly into the GitHub editor.)*

| Login Screen | Home Screen | Quiz Screen |
| :---: | :---: | :---: |
| <img src="![login](https://github.com/user-attachments/assets/9dbf5f4e-9e58-46bf-ba94-e963ca6bb71f)" width="250"> | <img src="URL_TO_YOUR_HOME_SCREENSHOT" width="250"> | <img src="URL_TO_YOUR_QUIZ_SCREENSHOT" width="250"> |

---

## ✨ Features

- **User Authentication:** Simple and secure user registration and login.
- **Question Categories:** Users can select from various topics like Science, History, Geography, and Movies.
- **Multiple Difficulty Levels:** Choose between Easy, Medium, and Hard to tailor the challenge.
- **Timed Quizzes:** Each quiz session has a countdown timer to test the user's speed and knowledge.
- **Real-time Feedback:** Instantly see if your selected answer is correct or incorrect.
- **Local Database:** Utilizes a local SQLite database to efficiently store and retrieve questions, answers, and categories.
- **Score Tracking:** Displays the final score and a summary after the quiz is completed.

---

## 🛠️ Tech Stack & Concepts

- **Framework:** Flutter
- **Language:** Dart
- **Database:** SQLite (`sqflite` package) for local data storage and management.
- **State Management:** Provider (`provider` package) for managing application state efficiently.
- **Asynchronous Programming:** `Future` and `async/await` for handling database operations without blocking the UI.
- **UI/UX:** Custom widgets, responsive layouts, and a clean, user-friendly design.
- **Project Structure:** Organized code into models, screens, services, and widgets for maintainability and scalability.

---

## 🚀 How to Run Locally

To get a local copy up and running, follow these simple steps.

### Prerequisites

- Flutter SDK installed.
- An emulator or a physical device to run the app.

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/favour-tamfu/flutter-quiz-game.git
    ```
2.  **Navigate to the project directory:**
    ```sh
    cd flutter-quiz-game
    ```
3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```
4.  **Run the app:**
    ```sh
    flutter run
    ```
