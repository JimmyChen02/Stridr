# Stridr 🏃‍♂️

**Welcome Runners to Stridr!** - A comprehensive iOS running tracking app that helps you track your runs, monitor your progress, and store your workout data securely in the cloud.

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Supabase](https://img.shields.io/badge/Supabase-Backend-green.svg)

## Features

- **Real-Time Run Tracking**: Track distance, pace, time, and calories burned
- **GPS Route Mapping**: Visual route tracking with MapKit integration
- **Advanced Timer**: Countdown start, pause/resume functionality
- **Workout History**: View all your past runs with detailed statistics
- ❤**HealthKit Integration**: Automatically sync workouts to Apple Health
- **Magic Link Authentication**: Secure passwordless login via email
- **Cloud Storage**: All workout data stored securely in Supabase
- **Native iOS Experience**: Built with SwiftUI for optimal performance

## Screenshots

The app includes:
- **Home View**: Map interface with start button
- **Countdown View**: 3-second countdown before run starts
- **Run View**: Live tracking display with distance, pace, and time
- **Pause View**: Pause screen with workout stats and resume/stop options
- **Activity View**: Complete workout history with detailed metrics
- **Login View**: Clean magic link authentication

## Tech Stack

- **Frontend**: SwiftUI (iOS 15.0+)
- **Backend**: Supabase (Database, Authentication, Real-time)
- **Language**: Swift 5.0
- **Maps**: MapKit with GPS tracking
- **Health**: HealthKit integration
- **Location**: Core Location Services
- **Authentication**: Supabase Auth with Magic Links

## Prerequisites

Before running this application, make sure you have the following:

- **Xcode 14.0+**
- **iOS 15.0+** target device or simulator
- **Apple Developer Account** (for device testing)
- **Supabase Account** and project
- **macOS Monterey** or later

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/JimmyChen02/Stridr.git
cd Stridr
```

### 2. Supabase Database Setup

Create the following table in your Supabase project:

```sql
CREATE TABLE workouts (
  id INT8 PRIMARY KEY,
  created_at TIMESTAMP DEFAULT now(),
  distance FLOAT8,
  pace FLOAT8,
  time INT8,
  user_id UUID,
  route JSONB
);
```

**Database Schema:**
```
workouts
├── id (int8, Primary Key)
├── created_at (timestamp, Default: now())
├── distance (float8)
├── pace (float8)
├── time (int8)
├── user_id (uuid)
└── route (jsonb)
```

### 3. Environment Configuration

The app supports two methods for configuration:

#### Configure Using Environment Variables 

1. In Xcode, go to **Product** → **Scheme** → **Edit Scheme**
2. Under **Run** → **Arguments** → **Environment Variables**, add:
   - `SUPABASE_URL`: Your Supabase project URL  
   - `SUPABASE_KEY`: Your Supabase anon key

#### Getting Your Supabase Credentials:

1. Go to [Supabase](https://supabase.com) and sign in
2. Select your project or create a new one
3. Navigate to **Settings** → **API**
4. Copy your **Project URL** and **anon/public key**

### 4. Configure URL Scheme

1. In Xcode, select your project target
2. Go to **Info** → **URL Types**
3. Add a new URL scheme: `com.stridr-ny`

### 5. Permissions Setup

The app requires the following permissions (already configured in code):
- **Location Services**: For GPS tracking during runs
- **HealthKit**: For syncing workout data to Apple Health

### 6. Build and Run

1. Open `Stridr.xcodeproj` in Xcode
2. Select your target device or simulator
3. Build and run the project (`Cmd + R`)

## App Architecture

### Key Components

- **ContentView**: Main app entry point with authentication state management
- **LoginView**: Magic link authentication interface
- **StridrTabView**: Main tab navigation (Run, Activity)
- **HomeView**: Map interface with run start functionality
- **RunTracker**: Core business logic for GPS tracking and workout management
- **CountdownView**: Pre-run countdown timer
- **RunView**: Active run tracking interface
- **PauseView**: Pause screen with workout controls
- **ActivityView**: Workout history and statistics

### Services

- **AuthService**: Handles Supabase authentication and session management
- **DatabaseService**: Manages workout data CRUD operations
- **HealthManager**: HealthKit integration for workout syncing

### Data Models

- **RunPayload**: Core workout data structure
- **GeoJSONCoordinate**: GPS coordinate storage format

## Usage

1. **Login**: Enter your email to receive a magic link
2. **Start Run**: Tap the start button on the home screen
3. **Track**: Watch the 3-second countdown, then start running
4. **Monitor**: View real-time distance, pace, and time
5. **Pause/Resume**: Use controls to pause and resume your run
6. **Stop**: Long-press the stop button to end your workout
7. **Review**: Check your workout history in the Activity tab

## Features in Detail

### GPS Tracking
- Real-time location updates with high accuracy
- Route visualization on interactive maps
- Distance calculation using Core Location
- Automatic pace calculation

### Workout Metrics
- **Distance**: Displayed in miles
- **Pace**: Calculated as minutes per mile
- **Time**: Elapsed time with pause/resume support
- **Calories**: Estimated based on speed, duration, and weight (180 lbs default)

### Data Storage
- Local workout history
- Cloud backup via Supabase
- HealthKit integration for Apple Health sync
- GeoJSON route storage for detailed tracking

## Privacy & Permissions

- **Location**: Required for GPS tracking during runs
- **HealthKit**: Optional, for syncing workouts to Apple Health
- **Authentication**: Email-based magic link authentication only

## Future Enhancements

- Social features for connecting with other runners
- Advanced workout analytics and insights
- Heart rate monitoring integration via Apple Watch analytics
- Custom workout goals and challenges

## Acknowledgments

- **Supabase** for backend infrastructure
- **Apple** for SwiftUI, MapKit, and HealthKit frameworks
- **Swift Community** for excellent development resources

---

**Happy Running! 🏃‍♂️💨**
