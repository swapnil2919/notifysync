# 🚀 Quick Start - 5 Minutes Mein Chalao!

## Prerequisites
- Flutter installed (`flutter --version`)
- Android Studio or VS Code
- USB phone ya Android Emulator

---

## Step 1: Setup (1 minute)

```bash
# Navigate to project
cd C:\dev\kaleidoscope\mobnitfication

# Install dependencies
flutter pub get
```

✅ Done! Dependencies install ho gaye.

---

## Step 2: Run on Emulator (1 minute)

```bash
# Android Emulator chalao (pehle se chalao ya command se)
flutter emulators

# OR Emulator pehle se chalao to:
flutter run
```

✅ App launch ho jayega!

---

## Step 3: Test Notifications (2 minutes)

### Pehli screen: "Get started"
- Button click karo
  
### Dusri screen: "Notification access change"
- Sab checkboxes already checked hain
- "Continue" button click karo

### Teesri screen: "Listening active"
- Yeh woh screen hai jo capture karte hain
- 4 buttons dikhe: SMS, Email, Order, Payment
- Kisi par click karo → Notification capture hoga!

### Chauthi screen: "Captured notifications"
- "View notifications" button se jaao
- Sab notifications dikhenge
- Green badge = sent, Orange = pending

### Panchvi screen: "Settings"
- Settings button click karo
- Server URL dekho
- User ID change kar sakte ho

---

## Step 4: Quick Testing Checklist

Run karte waqt check karo:

```
✅ App launches? 
✅ Home screen dikhta hai?
✅ "Get started" button clickable?
✅ Permissions screen open hota hai?
✅ Continue button kaam karta hai?
✅ Listening screen dikhta hai?
✅ Statistics dikhte hain (Captured: 0, Synced: 0)?
✅ Test buttons clickable?
✅ SMS button click → Notification dikhta hai?
✅ "View notifications" mein notification list dikhti hai?
✅ Settings screen open hota hai?
```

---

## Step 5: Console Logs Check

`flutter run` ke console mein ye logs dikhne chahiye:

```
🔧 Initializing Notifications...
✅ Notifications initialized

// Jab SMS button click karo:
📍 Capturing: SMS Alert
📤 Sending notification: SMS Alert
✅ Notification sent successfully
```

Agar ye logs nahi dikhe to kuch issue hai.

---

## Common Commands

```bash
# Run app
flutter run

# Run on specific device
flutter run -d emulator-5554

# List devices
flutter devices

# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Build APK
flutter build apk --release

# View logs
flutter logs
```

---

## File Structure Check

App files in order:
```
lib/
├── main.dart ✓
├── models/notification_model.dart ✓
├── services/
│   ├── api_service.dart ✓
│   └── notification_service.dart ✓
└── screens/
    ├── home_screen.dart ✓
    ├── permissions_screen.dart ✓
    ├── listening_screen.dart ✓
    ├── notifications_screen.dart ✓
    └── settings_screen.dart ✓

pubspec.yaml ✓
```

Sab files hain? ✅

---

## What's Working Now

### ✅ Fully Working
- App launch and navigation
- Dummy notifications creation
- Notification capture
- Local list storage
- Statistics display
- UI screens and buttons
- Settings configuration

### ⏳ Needs Backend
- Real API connection
- Database save
- Backend integration
- Dashboard fetch

---

## Backend Setup (When Ready)

### FastAPI Dummy Backend (Quick Test)

```python
# main.py
from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class Notification(BaseModel):
    user_id: str
    title: str
    message: str
    type: str
    timestamp: str

@app.post("/api/notifications")
async def create_notification(data: Notification):
    print(f"Received: {data.title}")
    return {"status": "created", "id": 1}

@app.get("/api/notifications")
async def get_notifications(user_id: str):
    return []

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
```

### Run Backend

```bash
pip install fastapi uvicorn
python main.py

# Server chalega: http://localhost:8000
```

---

## Troubleshooting

### Issue: "flutter: command not found"
**Fix:** Flutter PATH mein add karo
```bash
# Windows:
setx PATH "%PATH%;C:\flutter\bin"
```

### Issue: "No connected devices"
**Fix:** Emulator start karo ya USB phone connect karo
```bash
flutter emulators --launch emulator_name
```

### Issue: "Android SDK not found"
**Fix:** Android Studio se SDK download karo
```bash
flutter doctor --android-licenses
```

### Issue: App crash on launch
**Check:**
- `flutter pub get` run kiya?
- Sab files copy kiye?
- pubspec.yaml correct hai?

---

## Next Steps After Testing

1. **Backend create karo** (FastAPI)
2. **Database setup karo** (MySQL/PostgreSQL)
3. **API endpoints implement karo**
4. **Flutter app mein server URL update karo** (settings_screen.dart)
5. **Real notifications test karo**
6. **Deploy karo!**

---

## Important Notes

- 🔌 **Abhi Dummy API hai** - Backend ready hone tak test buttons use karo
- 📱 **Real Device mein APK build:** `flutter build apk --release`
- 🔐 **Production mein:** Authentication add karna zaroori hai
- 📊 **Dashboard:** Separately develop karna hoga (web/React/Vue)

---

## Video Recording Tips

Agar recording karna ho to:
1. Listening screen open rakho
2. Test button click karo
3. Notification capture dekhaao
4. "View notifications" mein list dekhaao
5. Settings mein server URL dekhaao

**Total recording: ~1 minute** 🎬

---

## Support

If stuck:
1. Check console logs
2. Read README.md
3. Check ARCHITECTURE.md
4. Look at code comments (Hindi + English)

---

**Happy coding! Agre koi issue ho to server logs check karo.** 🚀

