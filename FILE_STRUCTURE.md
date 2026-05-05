# IndEase Consumer App - File Structure

## 📁 Complete Project Structure

```
IndEaseConsumer/
│
├── 📱 App.jsx                          # Root component with providers
├── 📱 index.js                         # App entry point
├── 📦 package.json                     # Dependencies & scripts
├── ⚙️ app.json                         # App configuration
│
├── 📚 Documentation/
│   ├── README.md                       # Complete documentation
│   ├── SETUP.md                        # Setup guide
│   ├── QUICK_START.md                  # 5-minute quick start
│   ├── PROJECT_SUMMARY.md              # Feature overview
│   ├── INSTALLATION_CHECKLIST.md       # Verification checklist
│   └── FILE_STRUCTURE.md               # This file
│
├── 📂 src/
│   │
│   ├── 🧩 components/                  # Reusable UI Components (13)
│   │   ├── Badge.jsx                   # Status badges with colors
│   │   ├── Button.jsx                  # Multi-variant button
│   │   ├── Card.jsx                    # Shadow container
│   │   ├── ChatBubble.jsx              # Message bubble (left/right)
│   │   ├── EmptyState.jsx              # Empty list state
│   │   ├── Header.jsx                  # Screen header with back
│   │   ├── InputField.jsx              # Form input with validation
│   │   ├── LoadingSpinner.jsx          # Loading indicator
│   │   ├── QuoteCard.jsx               # Expert quote display
│   │   ├── RequestCard.jsx             # Request card with actions
│   │   ├── StatusStepper.jsx           # 4-step progress bar
│   │   └── Toast.jsx                   # Toast notification
│   │
│   ├── 📱 screens/                     # App Screens (18)
│   │   │
│   │   ├── 🔐 auth/                    # Authentication (2)
│   │   │   ├── LoginScreen.jsx         # Login with demo
│   │   │   └── RegisterScreen.jsx      # Registration form
│   │   │
│   │   ├── 🏠 home/                    # Home Dashboard (1)
│   │   │   └── HomeScreen.jsx          # Dashboard with stats
│   │   │
│   │   ├── 🚜 machines/                # Machine Management (2)
│   │   │   ├── MachinesScreen.jsx      # Machine list
│   │   │   └── MachineFormScreen.jsx   # Add/Edit machine
│   │   │
│   │   ├── 📋 requests/                # Service Requests (3)
│   │   │   ├── RequestsScreen.jsx      # All requests with filters
│   │   │   ├── RequestDetailsScreen.jsx # Full request details
│   │   │   ├── CreateRequestScreen.jsx  # 6-step request form
│   │   │   └── ViewQuotesScreen.jsx    # Compare quotes
│   │   │
│   │   ├── 💬 chat/                    # Messaging (2)
│   │   │   ├── ChatListScreen.jsx      # All conversations
│   │   │   └── ChatScreen.jsx          # Real-time chat
│   │   │
│   │   ├── 💳 payment/                 # Payments (1)
│   │   │   └── PaymentScreen.jsx       # Razorpay integration
│   │   │
│   │   ├── 👤 profile/                 # User Profile (1)
│   │   │   └── ProfileScreen.jsx       # Profile & settings
│   │   │
│   │   └── 🔔 notifications/           # Notifications (1)
│   │       └── NotificationsScreen.jsx # Notification list
│   │
│   ├── 🧭 navigation/                  # Navigation Setup (4)
│   │   ├── AppNavigator.jsx            # Root navigator
│   │   ├── AuthNavigator.jsx           # Auth stack
│   │   ├── MainNavigator.jsx           # Main tabs + stacks
│   │   └── TabBarIcon.jsx              # Tab icons
│   │
│   ├── 🌐 services/                    # API Services (7)
│   │   ├── api.js                      # Axios instance + interceptors
│   │   ├── authService.js              # Login, register, logout
│   │   ├── machineService.js           # Machine CRUD
│   │   ├── requestService.js           # Requests, quotes, confirm
│   │   ├── chatService.js              # Chat & messages
│   │   ├── paymentService.js           # Payment creation & verification
│   │   └── notificationService.js      # Notifications
│   │
│   ├── 🔌 socket/                      # Socket.IO (1)
│   │   └── socketService.js            # Real-time connection
│   │
│   ├── 🎯 context/                     # State Management (3)
│   │   ├── AuthContext.jsx             # User & authentication
│   │   ├── RequestContext.jsx          # Requests & updates
│   │   └── NotificationContext.jsx     # Notifications & count
│   │
│   ├── 🛠️ utils/                       # Helper Functions (3)
│   │   ├── statusHelpers.js            # Status labels, colors, actions
│   │   ├── formatters.js               # Date, currency, text formatting
│   │   └── validators.js               # Input validation
│   │
│   └── 📐 constants/                   # App Constants (3)
│       ├── api.js                      # API URLs
│       ├── colors.js                   # Brand colors
│       └── spacing.js                  # Spacing system
│
├── 🤖 android/                         # Android Configuration
│   ├── app/
│   │   └── src/
│   │       └── main/
│   │           └── AndroidManifest.xml # Permissions & config
│   └── build.gradle                    # Build configuration
│
└── 🍎 ios/                             # iOS Configuration (ready)
    └── (iOS files)
```

---

## 📊 File Count Summary

### Source Code
- **Components**: 13 files
- **Screens**: 18 files
- **Navigation**: 4 files
- **Services**: 7 files
- **Socket**: 1 file
- **Context**: 3 files
- **Utils**: 3 files
- **Constants**: 3 files

**Total Source Files**: 52

### Documentation
- README.md
- SETUP.md
- QUICK_START.md
- PROJECT_SUMMARY.md
- INSTALLATION_CHECKLIST.md
- FILE_STRUCTURE.md

**Total Documentation Files**: 6

### Configuration
- package.json
- app.json
- AndroidManifest.xml
- babel.config.js
- metro.config.js

**Total Config Files**: 5+

---

## 🎯 Key File Purposes

### Root Level
- **App.jsx** - Wraps app with Context providers
- **index.js** - Registers app with React Native
- **package.json** - Dependencies and scripts

### Components (src/components/)
All reusable UI components used across screens:
- Form elements (Button, InputField)
- Display elements (Card, Badge, Header)
- List elements (RequestCard, QuoteCard, ChatBubble)
- State elements (LoadingSpinner, EmptyState, Toast)
- Progress elements (StatusStepper)

### Screens (src/screens/)
Complete screens organized by feature:
- **auth/** - Login & registration
- **home/** - Main dashboard
- **machines/** - Machine management
- **requests/** - Request lifecycle
- **chat/** - Messaging system
- **payment/** - Payment processing
- **profile/** - User settings
- **notifications/** - Notification center

### Navigation (src/navigation/)
- **AppNavigator** - Switches between Auth/Main
- **AuthNavigator** - Login/Register stack
- **MainNavigator** - Bottom tabs + nested stacks
- **TabBarIcon** - Custom tab icons

### Services (src/services/)
API integration layer:
- **api.js** - Base Axios instance
- **authService** - Authentication APIs
- **machineService** - Machine APIs
- **requestService** - Request & quote APIs
- **chatService** - Chat APIs
- **paymentService** - Payment APIs
- **notificationService** - Notification APIs

### Socket (src/socket/)
- **socketService** - Real-time Socket.IO connection

### Context (src/context/)
Global state management:
- **AuthContext** - User authentication state
- **RequestContext** - Requests and updates
- **NotificationContext** - Notifications

### Utils (src/utils/)
Helper functions:
- **statusHelpers** - Status mapping & logic
- **formatters** - Data formatting
- **validators** - Input validation

### Constants (src/constants/)
App-wide constants:
- **api** - Backend URLs
- **colors** - Brand colors
- **spacing** - Spacing system

---

## 🔍 File Relationships

### Data Flow
```
User Action
    ↓
Screen Component
    ↓
Context (if needed)
    ↓
Service Layer
    ↓
API/Socket
    ↓
Backend
```

### Component Hierarchy
```
App.jsx
  ├── AuthProvider
  │     ├── RequestProvider
  │     │     ├── NotificationProvider
  │     │     │     └── AppNavigator
  │     │     │           ├── AuthNavigator (if not logged in)
  │     │     │           │     ├── LoginScreen
  │     │     │           │     └── RegisterScreen
  │     │     │           │
  │     │     │           └── MainNavigator (if logged in)
  │     │     │                 ├── HomeStack
  │     │     │                 ├── MachinesStack
  │     │     │                 ├── RequestsStack
  │     │     │                 ├── ChatStack
  │     │     │                 └── ProfileStack
```

---

## 📝 Import Patterns

### Component Import
```javascript
import Button from '../../components/Button';
import Card from '../../components/Card';
```

### Service Import
```javascript
import * as authService from '../../services/authService';
import { createRequest } from '../../services/requestService';
```

### Context Import
```javascript
import { useAuth } from '../../context/AuthContext';
import { useRequests } from '../../context/RequestContext';
```

### Utility Import
```javascript
import { formatCurrency } from '../../utils/formatters';
import { validateEmail } from '../../utils/validators';
```

### Constant Import
```javascript
import colors from '../../constants/colors';
import spacing from '../../constants/spacing';
```

---

## 🎨 Styling Pattern

All styles use:
- `wp()` and `hp()` for responsive dimensions
- `RFValue()` for responsive font sizes
- StyleSheet.create() for performance
- Consistent naming (camelCase)

Example:
```javascript
const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: wp('4%'),
    backgroundColor: colors.background,
  },
  title: {
    fontSize: RFValue(18),
    fontWeight: '700',
    color: colors.textPrimary,
  },
});
```

---

## 🔧 Configuration Files

### package.json
- Dependencies list
- Scripts for running/building
- Project metadata

### app.json
- App name and display name
- React Native configuration

### AndroidManifest.xml
- Android permissions
- App configuration
- Activity settings

---

## 📦 Build Outputs

### Debug Build
```
android/app/build/outputs/apk/debug/
└── app-debug.apk
```

### Release Build
```
android/app/build/outputs/apk/release/
└── app-release.apk
```

### AAB (Play Store)
```
android/app/build/outputs/bundle/release/
└── app-release.aab
```

---

## 🎯 Quick File Lookup

**Need to modify...**

- **Login logic?** → `src/screens/auth/LoginScreen.jsx`
- **API URLs?** → `src/constants/api.js`
- **Colors?** → `src/constants/colors.js`
- **Request creation?** → `src/screens/requests/CreateRequestScreen.jsx`
- **Socket events?** → `src/socket/socketService.js`
- **Payment flow?** → `src/screens/payment/PaymentScreen.jsx`
- **Navigation?** → `src/navigation/MainNavigator.jsx`
- **User state?** → `src/context/AuthContext.jsx`
- **API calls?** → `src/services/*.js`
- **Reusable button?** → `src/components/Button.jsx`

---

**This structure follows React Native best practices and ensures maintainability and scalability.**
