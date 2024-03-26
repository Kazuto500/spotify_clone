# Spotify Clone

## Description

Spotify Clone is a Flutter application that replicates the functionality of the popular Spotify music platform. Leveraging the official Spotify API, this mirror allows users to search for recommended music, manage playlists, and enjoy features similar to those offered by Spotify.

## Getting Started

To get started with the Spotify Clone project, follow these steps:

### Prerequisites

Ensure you have the following installed on your system:

- [Flutter](https://flutter.dev/) and all its dependencies
- A developer account on Spotify to obtain API credentials.

### Installation

1. Clone this repository to your local machine using Git:

    ````
    git clone https://github.com/Kazuto500/spotify_clone.git
    ````

2. Navigate to the project directory:

    ````
    cd spotify_clone
    ````

3. Install project dependencies using Flutter:

    ````
    flutter pub get
    ````

### Configuration

1. Obtain your Spotify API credentials by creating an application on the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard/applications).

  - Client Id
  - Client Secret
  - Redirect URIs - Example spotifyclone://sign

3. Create a configuration file `config.dart` in the `lib` directory and add your credentials as follows:

    ```dart
    // lib/data/api/api_spotify.dart

    class Config {
      static const String clientId = 'YOUR_CLIENT_ID';
      static const String clientSecret = 'YOUR_CLIENT_SECRET';
      static const String redirectUri = 'YOUR_REDIRECT_URI';
    }
    ```

    Replace `YOUR_CLIENT_ID`, `YOUR_CLIENT_SECRET`, and `YOUR_REDIRECT_URI` with your own credentials.

4. Enable MultiDex Support. In order to enable MultiDex support in your project, add `multiDexEnabled true` within `defaultConfig` in the `android/app/build.gradle` file:

````gradle
    // android/app/src/build.gradle

android {
    ...
    defaultConfig {
        ...
        multiDexEnabled true
    }
}
````
4. Verify Permissions and URL Scheme. Verify permissions and the URL scheme in the `AndroidManifest.xml` file to ensure they match the configuration of your project.

Example snippet from `AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <application
        ...
        android:enableOnBackInvokedCallback="true">
        <activity
            ...>
            ...
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="spotifyclone" android:host="sign" />
            </intent-filter>
        </activity>
        ...
    </application>
  ...
</manifest>
````
5. Be sure to review and adjust the values in the XML files, pubspec.yaml, build.gradle, and AndroidManifest.xml to verify that everything correctly matches the application requirements.

### Compilation
To compile there are two options:

1. To compile the application in debug mode, run the following command:
````
flutter run
````
2. To build the app to generate an apk on your mobile device, run the following command: 
````
flutter build apk
````
- Keep in mind that to generate an apk you must have your mobile device connected with USB debugging in the device manager of your code editor (vscode, android studio, etc).

