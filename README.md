# IA Browser - AI-Powered In-App Browser & Document Summarizer

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart" alt="Dart">
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-blue" alt="Platform">
</p>

A Flutter-based cross-platform application featuring an AI-powered in-app browser with document summarization, translation capabilities, and smart file management.

## ✨ Features

### 🌐 In-App Browser
- Full-featured browser using `flutter_inappwebview`
- Multi-tab support (up to 10 concurrent tabs)
- Navigation controls (Back/Forward/Refresh)
- URL bar with search engine integration
- Page loading indicators
- Secure connection indicators
- Download document support (PDF, DOCX, PPTX, XLSX)

### 🤖 AI Summary & Translation
- Extract readable text from web pages (DOM parsing)
- AI-based text summarization
- Word count reduction statistics
- Multi-language translation support (10+ languages)
- Copy, share, and download summaries
- Cached summaries for offline access

### 📁 Smart File Manager
- View and manage downloaded files
- Pick files from device storage
- Text extraction from PDF documents
- File metadata tracking (name, size, date, type)
- Storage usage monitoring

### 💾 Offline Mode & Caching
- Cache pages for offline viewing
- Save summaries locally using Hive
- Connectivity status monitoring
- Automatic offline mode switching

### 🎨 Modern UI/UX
- Cyber-minimal dark theme design
- Smooth animations with `flutter_animate`
- Responsive layout for mobile and web
- Material 3 design language

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── main.dart                    # App entry point
├── core/
│   ├── constants/               # App & API constants
│   ├── theme/                   # Theme configuration
│   ├── utils/                   # Utility functions
│   └── extensions/              # Dart extensions
├── data/
│   ├── datasources/             # Local storage (Hive)
│   ├── models/                  # Data models with Hive adapters
│   └── repositories/            # Repository implementations
├── domain/
│   ├── entities/                # Business entities
│   └── repositories/            # Repository interfaces
├── presentation/
│   ├── providers/               # Riverpod state management
│   ├── screens/                 # UI screens
│   └── widgets/                 # Reusable widgets
└── services/                    # App services
```

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Screens   │  │   Widgets   │  │  Riverpod Providers │  │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
└─────────┼────────────────┼────────────────────┼─────────────┘
          │                │                    │
          ▼                ▼                    ▼
┌─────────────────────────────────────────────────────────────┐
│                      DOMAIN LAYER                            │
│  ┌─────────────┐  ┌──────────────────┐  ┌───────────────┐   │
│  │  Entities   │  │   Repositories   │  │   Use Cases   │   │
│  │             │  │   (Interfaces)   │  │   (Future)    │   │
│  └─────────────┘  └────────┬─────────┘  └───────────────┘   │
└────────────────────────────┼────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                       DATA LAYER                             │
│  ┌─────────────┐  ┌──────────────────┐  ┌───────────────┐   │
│  │   Models    │  │   Repositories   │  │  Datasources  │   │
│  │  (Hive)     │  │ (Implementations)│  │    (Hive)     │   │
│  └─────────────┘  └──────────────────┘  └───────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.x (Stable) |
| **Language** | Dart 3.x |
| **State Management** | Riverpod |
| **Local Storage** | Hive |
| **Browser** | flutter_inappwebview |
| **HTTP Client** | Dio |
| **Animations** | flutter_animate |
| **PDF Processing** | syncfusion_flutter_pdf |

## 📦 Dependencies

### Core Dependencies
```yaml
flutter_riverpod: ^2.5.1          # State management
flutter_inappwebview: ^6.1.5       # In-app browser
hive_flutter: ^1.1.0               # Local storage
dio: ^5.7.0                        # HTTP client
file_picker: ^8.1.2                # File picking
path_provider: ^2.1.4              # Path utilities
```

### UI Dependencies
```yaml
flutter_animate: ^4.5.0            # Animations
shimmer: ^3.0.0                    # Loading effects
```

### Utility Dependencies
```yaml
connectivity_plus: ^6.0.5          # Network status
syncfusion_flutter_pdf: ^27.2.4    # PDF text extraction
share_plus: ^10.0.3                # Share functionality
uuid: ^4.5.1                       # Unique IDs
intl: ^0.19.0                      # Internationalization
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.x or higher
- Dart SDK 3.x or higher
- Android Studio / VS Code
- Xcode (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/ia_browser.git
   cd ia_browser
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For Android
   flutter run -d android

   # For iOS
   flutter run -d ios

   # For Web
   flutter run -d chrome
   ```

### Building for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 🔧 Configuration

### API Configuration

The app uses a mock AI summarization service by default. To integrate with real APIs:

1. **Summarization API**: Update `lib/core/constants/api_constants.dart`
2. **Translation API**: Configure LibreTranslate or Google Translate endpoints

### Storage Configuration

Hive boxes are configured in `lib/core/constants/app_constants.dart`:
- `tabs_box` - Browser tabs
- `settings_box` - App settings
- `cache_box` - Page cache
- `history_box` - Browsing history
- `downloads_box` - Downloaded files
- `summaries_box` - AI summaries

## 📱 Screens

| Screen | Description |
|--------|-------------|
| **Browser** | Main WebView with tab bar and URL input |
| **Files** | Downloaded documents and file picker |
| **Tabs** | Grid view of all open tabs |
| **Settings** | App configuration and data management |
| **History** | Browsing history with search |

## 🔐 State Management

**Why Riverpod?**

1. **Compile-time safety** - Catches errors at build time
2. **Testability** - Easy to mock and test providers
3. **No BuildContext dependency** - Access state anywhere
4. **Auto-disposal** - Automatic resource cleanup
5. **Scalability** - Handles complex state easily

### Provider Structure

```dart
// Repository providers
final browserRepositoryProvider = Provider<BrowserRepository>((ref) => ...);
final fileRepositoryProvider = Provider<FileRepository>((ref) => ...);
final aiRepositoryProvider = Provider<AIRepository>((ref) => ...);

// State notifier providers
final browserProvider = StateNotifierProvider<BrowserNotifier, BrowserState>(...);
final fileProvider = StateNotifierProvider<FileNotifier, FileState>(...);
final aiProvider = StateNotifierProvider<AINotifier, AIState>(...);
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(...);
```

## 🔄 API Flow for Summarization & Translation

### Summarization Flow

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│   WebView /     │     │   AI Provider    │     │  AI Repository  │
│   Document      │     │  (Riverpod)      │     │                 │
└────────┬────────┘     └────────┬─────────┘     └────────┬────────┘
         │                       │                        │
         │  1. Extract Text      │                        │
         │  (DOM/PDF parsing)    │                        │
         │──────────────────────>│                        │
         │                       │                        │
         │                       │  2. Check Cache        │
         │                       │───────────────────────>│
         │                       │                        │
         │                       │  3. Cache Miss?        │
         │                       │  Call Summarize API    │
         │                       │───────────────────────>│
         │                       │                        │
         │                       │     ┌──────────────────┴──────────────────┐
         │                       │     │  Mock Summarization Algorithm:      │
         │                       │     │  1. Clean HTML tags                 │
         │                       │     │  2. Split into sentences            │
         │                       │     │  3. Score by word frequency (TF-IDF)│
         │                       │     │  4. Select top sentences            │
         │                       │     │  5. Return condensed summary        │
         │                       │     └──────────────────┬──────────────────┘
         │                       │                        │
         │                       │  4. Cache Summary      │
         │                       │<───────────────────────│
         │                       │                        │
         │  5. Display Summary   │                        │
         │<──────────────────────│                        │
         │                       │                        │
```

### Translation Flow

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│  Summary Panel  │     │   AI Provider    │     │  Translation    │
│                 │     │                  │     │  Service        │
└────────┬────────┘     └────────┬─────────┘     └────────┬────────┘
         │                       │                        │
         │  1. Select Language   │                        │
         │  (hi/es/fr/de/etc.)   │                        │
         │──────────────────────>│                        │
         │                       │                        │
         │                       │  2. Call Translate     │
         │                       │  POST /translate       │
         │                       │  {q, source, target}   │
         │                       │───────────────────────>│
         │                       │                        │
         │                       │     ┌──────────────────┴──────────────────┐
         │                       │     │  LibreTranslate API (or Mock):      │
         │                       │     │  - Endpoint: libretranslate.com     │
         │                       │     │  - Fallback: Mock with indicator    │
         │                       │     └──────────────────┬──────────────────┘
         │                       │                        │
         │                       │  3. Return Translation │
         │                       │<───────────────────────│
         │                       │                        │
         │  4. Update Summary    │                        │
         │     with Translation  │                        │
         │<──────────────────────│                        │
```

### Data Flow Summary

| Step | Component | Action |
|------|-----------|--------|
| 1 | WebView | Extract page content via JavaScript injection |
| 2 | AIProvider | Receive text, check Hive cache for existing summary |
| 3 | AIRepository | If cache miss, run summarization algorithm |
| 4 | Hive Storage | Store summary with URL as key |
| 5 | SummaryPanel | Display with word count stats |
| 6 | Translation | On language select, call translation API |
| 7 | Cache | Store translation alongside summary |

### API Endpoints (Configurable)

```dart
// lib/core/constants/api_constants.dart

// Summarization (Mock - replace with real API)
static const String summarizationBaseUrl = 'https://api.smmry.com';

// Translation (LibreTranslate - free & open source)
static const String translationBaseUrl = 'https://libretranslate.com';
static const String translateEndpoint = '/translate';
```

## 🌍 Supported Languages (Translation)

- English (en)
- Hindi (hi)
- Spanish (es)
- French (fr)
- German (de)
- Chinese (zh)
- Japanese (ja)
- Arabic (ar)
- Portuguese (pt)
- Russian (ru)

## 📄 Supported Document Formats

- PDF (.pdf)
- Word Documents (.doc, .docx)
- PowerPoint (.ppt, .pptx)
- Excel (.xls, .xlsx)

## ⚠️ Known Limitations

1. **Web Platform**: WebView has limited functionality on web; shows fallback UI
2. **PDF Text Extraction**: Complex layouts may not extract perfectly
3. **Translation API**: Uses mock translation in demo mode
4. **iOS Simulator**: WebView may not render on certain simulators

## 🔮 Future Improvements

- [ ] Speech-to-text URL input
- [ ] Text-to-speech for summaries
- [ ] Firebase Crashlytics integration
- [ ] PWA install prompt
- [ ] Bookmark management
- [ ] Reading mode
- [ ] Custom user agents
- [ ] Ad blocking
- [ ] Download manager improvements
- [ ] Sync across devices

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📧 Contact

For questions or support, please open an issue on GitHub.

---

<p align="center">
  Built with ❤️ using Flutter
</p>
