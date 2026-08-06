# NotifySync Architecture

## 🏗️ High-Level Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    MOBILE (Flutter App)                         │
│                                                                 │
│  1. Notification Capture                                        │
│     └─ Notification System → Notification Service              │
│                                                                 │
│  2. Process                                                     │
│     └─ Add to local list                                       │
│     └─ Send to API                                             │
│                                                                 │
│  3. Display                                                     │
│     └─ Show in UI (Listening screen, Notifications screen)     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                             ↓ HTTP
┌─────────────────────────────────────────────────────────────────┐
│                    BACKEND (FastAPI)                            │
│                                                                 │
│  - Receive notification data                                    │
│  - Validate                                                     │
│  - Save to Database                                             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                             ↓ Query
┌─────────────────────────────────────────────────────────────────┐
│                    DATABASE                                     │
│                                                                 │
│  notifications table                                            │
│  ├─ id                                                          │
│  ├─ user_id                                                     │
│  ├─ title                                                       │
│  ├─ message                                                     │
│  ├─ type                                                        │
│  └─ timestamp                                                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                             ↓ GET
┌─────────────────────────────────────────────────────────────────┐
│                    DASHBOARD (Web)                              │
│                                                                 │
│  - Fetch all notifications                                      │
│  - Display in table/card format                                 │
│  - Analytics                                                    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📂 File Structure & Their Roles

### `main.dart`
**Kya hai:** App ka entry point
**Kya karte hai:**
- MaterialApp setup
- Theme set (dark mode)
- HomeScreen initialize

```dart
void main() {
  runApp(const MyApp());
}
```

---

### `models/notification_model.dart`
**Kya hai:** Notification ka data structure
**Kya karte hai:**
- Notification ko define karte hain
- `toJson()` method - API ko send karte wakt convert
- `copyWith()` method - data update karte wakt

```dart
NotificationModel {
  id, title, message, type, timestamp, isSent
}
```

---

### `services/notification_service.dart`
**Kya hai:** Notifications ko handle karna
**Kya karte hai:**
- Initialize notifications
- Capture notifications jab aaye
- Send to API
- Maintain list of captured notifications
- Calculate statistics (total, synced, pending)

**Important Methods:**
```dart
initialize()              // Setup karo
captureNotification()     // Notification capture ho to yeh call
sendToApi()              // API ko bhejo
showLocalNotification()   // Test ke liye local notification show
getStats()               // Statistics
```

---

### `services/api_service.dart`
**Kya hai:** Backend API se communicate karna
**Kya karte hai:**
- HTTP POST request - notification send karna
- HTTP GET request - notifications fetch karna
- Dummy notification generator - testing ke liye

**Important Methods:**
```dart
sendNotificationToApi()   // Notification API ko bhejo
getNotifications()        // API se fetch karo
createDummyNotification() // Fake notification banao (testing)
```

---

### Screen Files

#### `screens/home_screen.dart`
**Role:** Welcome screen
- Logo + Title
- "Get started" button
- Notification service initialize

#### `screens/permissions_screen.dart`
**Role:** Permission request
- Notification types select karna
- Checkboxes
- Continue button

#### `screens/listening_screen.dart`
**Role:** Active listening + Statistics
- Real-time stats (Captured, Synced, Queued)
- Test buttons (SMS, Email, Order, Payment)
- "View notifications" button
- Settings button

#### `screens/notifications_screen.dart`
**Role:** Captured notifications list
- List of all notifications
- Type icons
- Status badges (Sent/Pending)
- Timestamp

#### `screens/settings_screen.dart`
**Role:** Configuration
- Server URL
- User ID
- Sync interval
- API endpoints reference

---

## 🔄 Data Flow

### Scenario 1: Normal Notification Capture

```
1. Phone notification arrives
   ↓
2. NotificationService.captureNotification() call
   ↓
3. Add to NotificationService.capturedNotifications list
   ↓
4. NotificationService.sendToApi() call
   ↓
5. ApiService.sendNotificationToApi() do HTTP POST
   ↓
6. Update notification.isSent = true
   ↓
7. UI refresh - show in Notifications screen
```

### Scenario 2: API Mein Notifications Fetch Karna

```
1. Dashboard load hota hai
   ↓
2. GET /api/notifications?user_id=user123 call
   ↓
3. Backend database se query
   ↓
4. Return JSON array
   ↓
5. Dashboard parse aur display
```

### Scenario 3: Test Button Click (Listening Screen)

```
1. User "SMS" button click
   ↓
2. ApiService.createDummyNotification('sms') call
   ↓
3. Dummy NotificationModel banao
   ↓
4. NotificationService.captureNotification() call
   ↓
5. Same as Scenario 1
```

---

## 🌐 API Endpoints

| Method | Endpoint | Purpose | Body |
|--------|----------|---------|------|
| POST | `/api/notifications` | Send notification | `{user_id, title, message, type, timestamp}` |
| GET | `/api/notifications?user_id=X` | Fetch user notifications | None |
| GET | `/api/notifications/{id}` | Get single notification | None |
| PUT | `/api/notifications/{id}/read` | Mark as read | None |
| DELETE | `/api/notifications/{id}` | Delete notification | None |

---

## 💾 State Management

**Simple approach used:**
- No Provider/Bloc/Redux
- Simple `List<NotificationModel>` static list
- `StatefulWidget` setState() for UI refresh

```dart
// NotificationService.dart
static List<NotificationModel> capturedNotifications = [];
static int totalCaptured = 0;
static int totalSynced = 0;

// Usage in screens:
NotificationService.capturedNotifications.length
NotificationService.totalCaptured
NotificationService.totalSynced
```

---

## 🔐 Security Notes

**Currently:** Dummy API, no auth
**Production mein add karna:**

1. **Authentication:**
   - Bearer token
   - API key
   - OAuth

2. **Validation:**
   - User ID validation
   - Data validation
   - Rate limiting

3. **Encryption:**
   - HTTPS only
   - Sensitive data encryption
   - TLS

---

## 📱 Screen Navigation

```
HomeScreen
   ↓ (Get started)
PermissionsScreen
   ↓ (Continue)
ListeningScreen
   ├─ (Settings button) → SettingsScreen
   └─ (View notifications) → NotificationsScreen
      └─ (Back) → ListeningScreen
```

---

## ⚙️ Configuration Points

### In `api_service.dart`
```dart
static const String baseUrl = 'http://localhost:8000/api';
static String userId = 'user123';
```

Update these when backend ready!

### In `notification_service.dart`
```dart
// Change notification channel ID
const AndroidNotificationDetails(
  'notification_channel_id',  // Change this
  'Notifications',
)
```

---

## 🧪 Testing Strategy

### 1. Local Testing (Listening Screen)
- Test buttons se dummy notifications
- Verify capture aur UI update

### 2. API Testing (Settings Screen)
- Show REST endpoints
- Can test with Postman
- Verify server URL

### 3. Integration Testing
- Real backend with Flutter
- End-to-end notification flow

### 4. Dashboard Testing
- Fetch notifications from API
- Display correctly

---

## 🚀 Deployment Checklist

- [ ] Backend FastAPI app ready
- [ ] Database configured
- [ ] API endpoints implemented
- [ ] HTTPS enabled
- [ ] Authentication added
- [ ] Flutter app server URL updated
- [ ] Build APK/IPA
- [ ] Test on real device
- [ ] Dashboard deployed

---

## 📊 Example Database Schema

```sql
CREATE TABLE notifications (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id VARCHAR(100) NOT NULL,
  title VARCHAR(255) NOT NULL,
  message TEXT NOT NULL,
  type VARCHAR(50),  -- 'sms', 'email', 'order', etc
  read BOOLEAN DEFAULT FALSE,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user_id (user_id),
  INDEX idx_timestamp (timestamp)
);
```

---

## 🎯 Performance Considerations

1. **Notification List:** 
   - 100-1000 notifications OK
   - Beyond 1000 → pagination needed

2. **API Calls:**
   - Real-time send OK
   - Batch mode for offline scenarios

3. **Local Storage:**
   - Currently in-memory only
   - For persistence → SharedPreferences

4. **Network:**
   - 10 second timeout
   - Retry logic available

---

## 🔗 Integration Points

```
Flutter App ↔ FastAPI Backend ↔ Database
    ↑                              ↓
    └─────────────────────────────┘
         (GET notifications)

Dashboard ↔ FastAPI Backend ↔ Database
```

---

**Keep this simple! More features add karna baad mein.** 🚀
