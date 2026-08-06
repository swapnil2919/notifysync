NotifySync - Flutter Notification App

A simple Flutter app that captures notifications and sends them to anAPI.

📁 Project Structure

lib/
├── main.dart                      # App entry point
├── models/
│   └── notification_model.dart    # Notification data model
├── services/
│   ├── api_service.dart           # API calls and dummy data
│   └── notification_service.dart  # Notification handling
└── screens/
    ├── home_screen.dart           # Welcome screen
    ├── permissions_screen.dart    # Permission requests
    ├── listening_screen.dart      # Active listening and statistics
    ├── notifications_screen.dart  # Captured notifications list
    └── settings_screen.dart       # Settings and API configuration

🚀 Setup

Step 1: Create a Flutter Project

flutter create notifysync
cd notifysync

Step 2: Copy the Files

Replace the pubspec.yaml file.

Copy all files into the lib/ folder.

Step 3: Install Dependencies

flutter pub get

Step 4: Run the App

flutter run

📱 App Flow

Home Screen (Get Started)
    ↓
Permissions Screen (Choose notification types)
    ↓
Listening Screen (Active listening + test buttons)
    ↓
Notifications Screen (Captured notifications)
    ↓
Settings Screen (API configuration)

🔧 Main Features

1. Notification Capture

Listens for notifications.

Sends captured notifications to the API.

Stores notifications locally.

2. Dummy Testing

The Listening screen includes four test buttons:

SMS -- Test SMS notification

Email -- Test email notification

Order -- Test order shipped notification

Payment -- Test payment received notification

Click any button to simulate a notification. The app captures it andsends it to the API.

3. Real-Time Sync

Notifications are sent to the API immediately after being captured.

Displays whether each notification is Pending or Synced.

4. Settings

Set the server URL.

Set the user ID.

View API endpoints.

Configure sync settings.

📡 API Integration

Current Status: Dummy API

The app currently uses dummy data. When your backend is ready, updatelib/services/api_service.dart.

API Endpoints

1. Send Notification

POST http://localhost:8000/api/notifications

Request Body:

{
  "user_id": "user123",
  "title": "Order Shipped",
  "message": "Your order has been shipped",
  "type": "order",
  "timestamp": "2026-08-06T10:30:00"
}

Response:

{
  "status": "created",
  "id": 1
}

2. Get Notifications

GET http://localhost:8000/api/notifications?user_id=user123

Response:

[
  {
    "id": 1,
    "title": "Order Shipped",
    "message": "Your order has been shipped",
    "type": "order",
    "timestamp": "2026-08-06T10:30:00",
    "isSent": true
  }
]

🎯 Quick Testing

Launch the app.

Click Get Started.

Select the required permissions and continue.

On the Listening screen, click a test button (SMS, Email, Order, orPayment).

A notification will be captured.

Click View Notifications.

Check the captured notifications list.

Open Settings to review the API configuration.

🔌 Backend Integration

Step 1: Create a FastAPI Backend

from fastapi import FastAPI
from pydantic import BaseModel
from datetime import datetime

app = FastAPI()

class NotificationCreate(BaseModel):
    user_id: str
    title: str
    message: str
    type: str
    timestamp: datetime

@app.post("/api/notifications")
async def create_notification(notif: NotificationCreate):
    return {"status": "created", "id": 1}

@app.get("/api/notifications")
async def get_notifications(user_id: str):
    return []

Step 2: Run the Backend

pip install fastapi uvicorn
uvicorn main:app --reload

Step 3: Update the Flutter App

In lib/services/api_service.dart:

static const String baseUrl = 'http://YOUR_SERVER:8000/api';

📊 Data Model

NotificationModel {
  id: String,
  title: String,
  message: String,
  type: String,          // sms, email, order, payment
  timestamp: DateTime,
  isSent: bool           // Whether it was sent to the API
}

🐛 Debugging Tips

Check the console logs while running:

📤 Sending notification...

✅ Notification sent successfully

❌ Failed: 404

Check the statistics on the Listening screen:

Captured count

Synced count

Queued count

Test the API:

Review the endpoints in the Settings screen.

Test them using Postman.

✅ Checklist

Flutter is installed (flutter --version)

Dependencies are installed (flutter pub get)

The app runs successfully (flutter run)

Dummy testing works

Notifications are captured correctly

Backend is ready

API URL is updated

Real notifications are being sent

🎨 UI Components

Dark theme with blue and teal gradient

Simple and easy-to-use buttons

Status badges for Pending and Synced notifications

Icons for SMS, Email, Order, and Payment

Statistics for Captured, Synced, and Queued notifications

📝 Code Quality

The code is written to be simple and easy to understand.

Clear comments

Simple logic

Meaningful variable names

One function for one task

🆘 Common Issues

Issue: "No python application found"

Solution: Restart the app and check the backend logs.

Issue: Notifications are not sending

Solution: Check your internet connection and verify the API URL.

Issue: "Connection refused"

Solution: Make sure the backend server is running onlocalhost:8000.

🚀 Next Steps

Build the backend using FastAPI.

Set up a database (PostgreSQL or MySQL).

Implement the API endpoints.

Update the server URL in the Flutter app.

Test with real notifications.

Deploy the application.
