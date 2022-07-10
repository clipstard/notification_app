# ThreeUK

## Prerequisites

1. Flutter • ^2.2.0
2. Tools • Dart ^2.13.0

## Installation

https://flutter.dev/docs/get-started/install

* Enter the app directory `cd app/`
* Copy and rename file `cp .env.dist .env`
* Get packages `flutter pub get`

# Deployment

Build app documentation https://flutter.dev/docs/deployment/android

# Development

Run app CLI `flutter run`

### Web (run in browser)

1. `flutter config --enable-web` run once (if it's not the case)
2. `flutter run -d chrome`

### For linux check requirements

https://pub.dev/packages/flutter_secure_storage

### Recommended naming conventions

#### States:

Bloc(or cubit) subject + action + state of the action

##### Examples:

```
Weather block > WeatherFetchSuccess, WeatherFetchInProgress etc.
User cubit > UserCreateSuccess, UserCreateInProgress etc.
```

#### Events: Bloc(or cubit) subject + action(event) in past tense

##### Example:

```
UserBloc > UserFetched, UserDeleted etc.
```

#### Functions:

Action on what the cubit is working on

##### Example:


```
UserCubit: Fetch, Delete, Create etc.
```

# Tests

## e2e Web

Follow docs: https://flutter.dev/docs/cookbook/testing/integration/introduction#6b-web

## unit

1. Generate mocks `flutter pub run build_runner build`
2. Run `flutter test test/{file_name}.dart`

Documentation https://pub.dev/packages/test

# Storybook

1. this project using Dashbook  
https://pub.dev/packages/dashbook
2. to build it run command `flutter run -t stories/main_story.dart`

# QA & Test Accounts

## Login

* login: `test@gmail.com`
* password: `test`


## MSISDN
    For each number you can use any prefix from [07, 447, +447]

## OTP

`999999` - Valid OTP passcode for test

# Build and share the app

## For test purpose within *Firebase App distribution*

1. In `pubspec.yaml` change `version` wit expected one  
For example with `version: 2.0.0+8`.  
In this case version name is `2.0.0`  
and version code is `8`
2. for Android generate signed apk `flutter build apk`
3. for iOS generate archive bundle `flutter build ipa`
4. open the generated Runner.xcarchive in step 3 and generate ipa buy distribute app in Ad Hoc mode.  
iOS sign-in ipa still pending: need more authorizations access in three Apple store
5. go to https://console.firebase.google.com/project/three-uk-loyalty-5181d/appdistribution/ and upload your app
