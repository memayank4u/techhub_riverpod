# TechHub (Riverpod Edition)

A production-grade, modern Flutter showcase application built with **Clean Architecture**, **Flutter Riverpod (StateNotifier & Providers)**, **Dio Network Engine**, **Offline-First Hive Storage (Single Source of Truth)**, and **Google Gemini Generative AI**.

---

## 🏛️ Architecture Overview

The project follows strict **Clean Architecture** principles with declarative compile-time safe Riverpod providers:

```
lib/
├── core/                         # Infrastructure & Common Services
│   ├── constants/                # Zero hardcoding: Strings, Dimensions
│   ├── network/                  # Centralized DioClient (Interceptors & Timeouts)
│   ├── storage/                  # HiveService (Single Source of Truth)
│   ├── theme/                    # Dynamic 3-Palette Theme Engine & ThemeNotifier
│   ├── di/                       # Riverpod Providers tree
│   └── common/                   # Resource<T> & Failure definitions
├── domain/                       # Pure Business Logic (100% Framework Agnostic)
│   ├── entities/                 # Immutable business models (Equatable)
│   ├── repositories/             # Abstract repository contracts
│   └── usecases/                 # Single-responsibility use cases
├── data/                         # Data Access & Mapping Layer
│   ├── models/                   # JSON / Hive serializable DTOs
│   ├── datasources/              # Remote (Dio) & Local (Hive) data sources
│   └── repositories/             # Repository implementations (SSOT strategy)
└── presentation/                 # UI & State Management
    ├── notifiers/                # StateNotifier classes & States
    ├── pages/                    # ConsumerWidget & ConsumerStatefulWidget screens
    └── widgets/                  # Atomic & reusable widgets
```

---

## ✨ Features

1. **Crypto Markets**:
   - Live coin prices, market cap, rank, and 24h price changes powered by CoinGecko API.
   - High-performance custom Canvas sparkline trend charts.
   - Real-time client-side search filtering.
   - Instant offline fallback via Hive cache.

2. **Tech Articles**:
   - Dev.to tech feed integration.
   - Filter chips and article reading time calculation.
   - Offline bookmarking (CRUD) preserved across network sync cycles.
   - External deep-linking with `url_launcher`.

3. **AI Mock Interview Coach**:
   - Real-time question generation tailored to topic and seniority level.
   - Streaming answer evaluation powered by **Google Gemini API**.
   - Dynamic score calculation (0–100) with visual score badge.
   - Full offline session history and review.

4. **Dynamic Theme Engine**:
   - 3 distinct Material 3 color palettes:
     - 🔷 **Cobalt Blue**
     - 🌿 **Emerald Mint**
     - 🔮 **Amethyst Purple**
   - 3 display modes: System default, Light, and Dark.
   - Persistent theme preferences via Hive.

5. **Networking (Dio Engine)**:
   - Configured with Google-recommended best practices:
   - Centralized `DioClient` with 15-second connect/receive/send timeouts.
   - Network request/response/error logging interceptors.
   - Typed error mapping (`DioException`).

---

## 🚀 Getting Started

### Prerequisites
- Flutter 3.27+ / 3.38+
- Dart 3.6+
- Android SDK 34+

### Installation & Run
```bash
# Clone the repository
cd techhub_riverpod

# Get dependencies
flutter pub get

# Run unit tests
flutter test

# Run on connected device
flutter run
```
