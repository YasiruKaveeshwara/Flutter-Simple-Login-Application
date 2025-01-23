# 🌟 Sample Flutter App

An impressive mobile application built using **Flutter** with key functionalities including user authentication via an API, local data storage using SQLite, and seamless navigation between screens. The app is designed to provide a modern UI/UX and robust features.

---

## ✨ Key Features

- **🔐 Login Functionality**:
  - Users can log in using their username (email) and password.
  - API authentication using the provided endpoint.
  - Local user data storage in SQLite.
- **📂 SQLite Integration**:
  - Stores user details locally for offline access.
  - Displays SQLite data in the app for transparency.
- **💾 Persistent Login**:
  - Remembers logged-in users and bypasses the login screen unless logged out.
- **🎨 Modern UI/UX**:
  - Responsive design with a light blue theme.
  - Error handling with user-friendly messages.

---

## 🛠 Tech Stack

- **Flutter**: Cross-platform mobile app development framework.
- **Dart**: Programming language for Flutter.
- **SQLite**: Local database for persistent storage.
- **SharedPreferences**: Persistent storage for lightweight key-value pairs.
- **API Integration**: HTTP requests using the `http` package.
- **dotenv**: Secure management of environment variables.

---

## 📥 Installation Guide

### Prerequisites

Ensure the following are installed:

- Flutter SDK ([📥 Download Flutter](https://flutter.dev/docs/get-started/install))
- Dart SDK
- Android Studio / VS Code (IDE)
- Android/iOS Emulator or physical device

### Steps to Install

1. **📂 Clone the repository**:

   ```bash
   git clone https://github.com/YasiruKaveeshwara/Flutter-Simple-Login-Application
   cd Flutter-Simple-Login-Application
   ```

2. **📦 Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **🔑 Add environment variables**:

   - Create a `.env` file in the root directory.
   - Add the following:
     ```env
     API_URL= <Add the user login authentication API key>
     API_ACTION= <Add API action Ex:- GetUserData>
     ```

4. **▶️ Run the app in debug mode**:
   ```bash
   flutter run
   ```

---

## 🚀 Building Release APK

To generate a release APK:

1. **📦 Build the release APK**:

   ```bash
   flutter build apk --release
   ```

2. The APK will be available at:

   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

3. **📱 Install the APK on your device**:
   ```bash
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

---

## 🛡 Usage Guide

### Recommended User Data

Note: Please use the username and password provided to you as part of your API access credentials. Contact your API administrator if you do not have them.

- **👤 Username**: `-`
- **🔑 Password**: `-`

### Features to Explore

- Log in using the API credentials.
- View user details after successful login.
- Navigate to the database screen to view locally stored SQLite data.
- Logout functionality to clear the saved user.

---

## 🗺 App Navigation

| 🖥 Screen            | 📋 Description                                   |
| ------------------- | ------------------------------------------------ |
| **Login Screen**    | Allows users to log in using email and password. |
| **Home Screen**     | Displays user details fetched from the database. |
| **Database Screen** | Shows SQLite data in a tabular format.           |

---

## 🛠 Troubleshooting

### Common Issues

1. **❌ Failed to Resolve API Endpoint**

   - Ensure the device has an active internet connection.
   - Verify the API endpoint in the `.env` file.

2. **❌ Database Errors**

   - Check if the SQLite database is initialized properly.
   - Ensure that data types and constraints are correct.

3. **🐢 Slow App Startup**
   - Run the app in release mode to optimize performance.
   ```bash
   flutter build apk --release
   ```

---

## 📜 License

This project is licensed under the **MIT License**. Feel free to use, modify, and distribute it as per the terms of the license.

---

## 📞 Contact

For any queries or issues, please contact:

- **📧 Email**: kaveeshwaray@gmail.com
- **👨‍💻 Author**: Yasiru Kaveeshwara
