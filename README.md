# IndEase Consumer Mobile App

A production-ready React Native CLI application for consumers to request and manage agricultural machinery repair services.

## 🚀 Features

### Core Functionality
- **User Authentication**: Login, Register, Demo Login
- **Machine Management**: Add, edit, delete machines
- **Service Requests**: Create detailed service requests with AI analysis
- **Expert Quotes**: Receive and compare quotes from multiple experts
- **Real-time Updates**: Socket.IO integration for live status updates
- **In-app Chat**: Direct messaging with assigned experts
- **Secure Payments**: Razorpay integration with escrow system
- **Request Tracking**: Full lifecycle tracking from broadcast to completion
- **Notifications**: Real-time push notifications for all updates
- **Rating System**: Rate experts after service completion

### Technical Highlights
- **Responsive Design**: Works on all Android screen sizes using wp/hp
- **Offline Handling**: Graceful error handling and retry mechanisms
- **Real-time Socket**: Live updates for quotes, status changes, messages
- **Context API**: Efficient state management
- **Type-safe**: Proper validation and error handling
- **Production Ready**: Security, performance, and UX best practices

## 📋 Prerequisites

- Node.js >= 18
- React Native CLI
- Android Studio with Android SDK
- JDK 17
- A running IndEase backend server

## 🛠️ Installation

### 1. Clone and Install Dependencies

```bash
cd IndEase-Mobile-Apk/IndEaseConsumer
npm install
```

### 2. Install iOS Dependencies (if building for iOS)

```bash
cd ios
pod install
cd ..
```

### 3. Link Native Dependencies

```bash
npx react-native link react-native-vector-icons
npx react-native link @react-native-async-storage/async-storage
```

### 4. Configure Android

The AndroidManifest.xml is already configured with necessary permissions:
- Internet access
- Camera access (for image/video upload)
- Storage access (for media selection)

### 5. Setup Backend Connection

The app is pre-configured to connect to:
- **API Base URL**: `http://10.0.2.2:5000/api` (Android emulator localhost)
- **Socket URL**: `http://10.0.2.2:5000`

To change these, edit `src/constants/api.js`:

```javascript
export const BASE_URL = 'http://10.0.2.2:5000/api';
export const SOCKET_URL = 'http://10.0.2.2:5000';
```

For physical devices, replace `10.0.2.2` with your computer's local IP address.

## 🏃 Running the App

### Start Metro Bundler

```bash
npm start
```

### Run on Android

```bash
npm run android
```

Or manually:

```bash
npx react-native run-android
```

### Run on iOS (macOS only)

```bash
npm run ios
```

## 🧪 Demo Login

Use these credentials to test the app:

- **Email**: demo@consumer.com
- **Password**: demo123

Or click the "Demo Login" button on the login screen.

## 📱 App Structure

```
src/
├── components/          # Reusable UI components
│   ├── Button.jsx
│   ├── Card.jsx
│   ├── InputField.jsx
│   ├── Badge.jsx
│   ├── StatusStepper.jsx
│   ├── RequestCard.jsx
│   ├── QuoteCard.jsx
│   ├── ChatBubble.jsx
│   ├── Header.jsx
│   ├── EmptyState.jsx
│   ├── LoadingSpinner.jsx
│   └── Toast.jsx
│
├── screens/             # All app screens
│   ├── auth/           # Login, Register
│   ├── home/           # Home dashboard
│   ├── machines/       # Machine management
│   ├── requests/       # Request lifecycle
│   ├── chat/           # Messaging
│   ├── payment/        # Payment processing
│   ├── profile/        # User profile
│   └── notifications/  # Notifications
│
├── navigation/          # Navigation setup
│   ├── AppNavigator.jsx
│   ├── AuthNavigator.jsx
│   ├── MainNavigator.jsx
│   └── TabBarIcon.jsx
│
├── services/            # API services
│   ├── api.js          # Axios instance
│   ├── authService.js
│   ├── machineService.js
│   ├── requestService.js
│   ├── chatService.js
│   ├── paymentService.js
│   └── notificationService.js
│
├── socket/              # Socket.IO integration
│   └── socketService.js
│
├── context/             # React Context providers
│   ├── AuthContext.jsx
│   ├── RequestContext.jsx
│   └── NotificationContext.jsx
│
├── utils/               # Helper functions
│   ├── statusHelpers.js
│   ├── formatters.js
│   └── validators.js
│
└── constants/           # App constants
    ├── api.js
    ├── colors.js
    └── spacing.js
```

## 🔄 Consumer Workflow

### Step 1: Create Service Request
- Select machine from your fleet
- Describe the issue (minimum 20 characters)
- Upload photo/video (optional)
- Set urgency level (Low/Normal/Critical)
- Choose preferred date and time slot
- Provide budget hint (optional)

### Step 2: AI Analysis
- Backend AI analyzes the request
- Returns machine type, issue summary, and confidence score
- Request is broadcast to nearby experts

### Step 3: Receive Quotes
- Up to 2 experts can submit quotes
- Each quote includes:
  - Expert profile (name, rating, level)
  - Diagnosis and assessment
  - Scope of work
  - Cost breakdown (labour + parts)
  - Estimated hours
  - Availability
- Real-time notification when quotes arrive

### Step 4: Approve Quote & Pay
- Compare quotes side-by-side
- Ask questions via chat
- Approve preferred quote
- Pay via Razorpay (escrow)
- Payment held until completion

### Step 5: Expert Travels
- Track expert status: "Expert On The Way"
- Chat with expert in real-time
- Receive updates via notifications

### Step 6: Repair In Progress
- Status updates to "Repair In Progress"
- Continue chatting with expert
- Expert can send photos/updates

### Step 7: Confirm Completion
- Expert marks job complete
- Consumer receives "Please Confirm" notification
- Review work and confirm
- Payment automatically released from escrow

### Step 8: Rate Expert
- Rate expert (1-5 stars)
- Write review
- Helps other consumers choose experts

### Step 9: Follow-up Window
- 7-day follow-up period
- If issue recurs, raise follow-up request
- Expert must address at no extra cost

## 🎨 Design System

### Colors
- **Primary**: #0d9488 (Teal)
- **Secondary**: #6366f1 (Indigo)
- **Success**: #10b981 (Green)
- **Warning**: #f59e0b (Amber)
- **Error**: #ef4444 (Red)

### Status Colors
- **Broadcast**: Yellow (Searching)
- **Quote Submitted**: Indigo (Pulsing)
- **Quote Approved**: Blue
- **En Route**: Purple
- **In Progress**: Orange
- **Pending Confirmation**: Amber (Action needed)
- **Completed**: Green
- **Cancelled**: Red

### Typography
- All font sizes use `RFValue()` for responsiveness
- Headings: 18-28px
- Body: 13-16px
- Captions: 11-12px

### Spacing
- Uses 8px grid system via `wp()` and `hp()`
- Consistent padding: 16px (wp('4%'))
- Card border radius: 12-16px

## 🔐 Security

- JWT tokens stored in AsyncStorage
- Automatic token refresh on 401
- All API calls include Authorization header
- Input validation on all forms
- Secure payment via Razorpay
- No sensitive data in logs

## 🚨 Error Handling

- Try-catch on all async operations
- Toast notifications for user feedback
- Graceful offline handling
- Empty states for all lists
- Loading spinners during API calls
- Network error retry mechanisms

## 📡 Real-time Features

### Socket Events Listened:
- `request_status_updated`: Update request status in real-time
- `quote_received`: Show notification when new quote arrives
- `job_pending_confirmation`: Alert when expert completes work
- `new_message`: Update chat in real-time
- `invoice_received`: Open payment screen

### Socket Events Emitted:
- `join`: Join user's room on connect
- `send_message`: Send chat message

## 🧩 Key Components

### RequestCard
- Shows machine name, issue, status badge
- 4-step progress indicator
- Context-aware action buttons
- Real-time status updates

### QuoteCard
- Expert profile with avatar
- Rating and experience
- Diagnosis and scope
- Cost breakdown
- Approve and chat buttons

### StatusStepper
- Visual 4-step progress bar
- Submitted → Quote → In Progress → Done
- Color-coded based on current step

### ChatBubble
- Left/right alignment based on sender
- Timestamp and read receipts
- Support for special message types (invoice, appointment)

## 🔧 Troubleshooting

### Metro Bundler Issues
```bash
npm start -- --reset-cache
```

### Android Build Errors
```bash
cd android
./gradlew clean
cd ..
npm run android
```

### Socket Connection Issues
- Ensure backend is running
- Check BASE_URL and SOCKET_URL in `src/constants/api.js`
- For physical devices, use local IP instead of 10.0.2.2

### Image Picker Not Working
```bash
npx react-native link react-native-image-picker
```

Then rebuild:
```bash
npm run android
```

## 📦 Building for Production

### Android APK

```bash
cd android
./gradlew assembleRelease
```

APK location: `android/app/build/outputs/apk/release/app-release.apk`

### Android AAB (for Play Store)

```bash
cd android
./gradlew bundleRelease
```

AAB location: `android/app/build/outputs/bundle/release/app-release.aab`

## 🧪 Testing

### Run Tests
```bash
npm test
```

### Test Coverage
```bash
npm test -- --coverage
```

## 📝 Environment Variables

Create `.env` file in root:

```env
API_BASE_URL=http://10.0.2.2:5000/api
SOCKET_URL=http://10.0.2.2:5000
RAZORPAY_KEY=your_razorpay_key
```

## 🤝 Contributing

1. Follow the existing code structure
2. Use functional components with hooks
3. Add proper error handling
4. Test on multiple screen sizes
5. Follow the design system

## 📄 License

Proprietary - IndEase Platform

## 🆘 Support

For issues or questions:
- Check the troubleshooting section
- Review the backend API documentation
- Contact the development team

---

**Built with ❤️ using React Native CLI**
