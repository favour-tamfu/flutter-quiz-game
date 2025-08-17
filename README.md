#  Flutter Quiz Game

A dynamic and engaging quiz application built with Flutter that challenges users with questions across various categories and difficulty levels. The app features a clean user interface, timed quizzes, and local data persistence using an SQLite database.

---

## 📸 Screenshots



| Login Screen | Home Screen | Quiz Screen |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/178bac46-d9a2-4bf7-b5e4-cc708c688b06" width="250"> | <img src="https://github.com/user-attachments/assets/7110f027-7efa-40a0-a3fd-be0da9467908" width="250"> | <img src="https://github.com/user-attachments/assets/52d89f6c-7480-4b8a-953d-2764b8aed945" width="250"> |






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
