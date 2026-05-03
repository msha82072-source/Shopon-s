# 🛍️ SHOPON'S — Fashion E-Commerce App

> **Shop Smart, Live Better**

A multi-vendor fashion e-commerce application built with Flutter for Android and Web as a solo learning project. The app is actively under development.

---

## ⚠️ Project Status

> This project is currently **in active development**.
> Some features are complete, some are partially working, and some are still being fixed.
> This is a **solo learning project** — not a production app.

| Area | Status |
|------|--------|
| Authentication (Login / Signup) | ✅ Working |
| Splash Screen | ✅ Working |
| Home Page | 🔄 Partially Working |
| Product Listing | 🔄 Partially Working |
| Cart | 🔄 Partially Working |
| Wishlist | 🔄 Partially Working |
| Checkout | 🔄 In Progress |
| Order Tracking | 🔄 In Progress |
| Vendor Dashboard | ⚠️ Buggy — Being Fixed |
| Admin Panel | ⚠️ Buggy — Being Fixed |
| Animations & UI Polish | 🔄 In Progress |

---

## 📱 Platform

- ✅ Android
- ✅ Web (Flutter Web)
- ❌ iOS (not included)

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter |
| State Management | GetX |
| Backend | Supabase |
| Auth | Supabase Auth |
| Database | Supabase PostgreSQL |
| Storage | Supabase Storage |

---

## ✨ Features

### ✅ Working
- User signup and login with email & password
- Password reset
- Role-based access (Customer / Vendor / Admin)
- Splash screen with animation
- Basic home page layout
- Product browsing

### 🔄 Partially Working
- Product search and filtering
- Cart (add/remove working, some edge cases)
- Wishlist
- Home page banners
- Product detail page

### ⚠️ Known Issues
- Vendor dashboard has navigation and data loading bugs
- Admin panel has UI and functionality issues
- Some home page widgets not loading correctly
- Order history not fully connected to Supabase
- Web layout needs responsiveness fixes

---

## 🎨 UI Theme

| Role | Color | Hex |
|------|-------|-----|
| Primary (60%) | Navy Blue | `#1B2A4A` |
| Secondary (30%) | Cream | `#F5EDD7` |
| Accent (10%) | Gold | `#C9A84C` |

---

## 🗄️ Database Tables

```
users
vendor_profiles
categories
products
product_variants
product_images
cart
favorites
addresses
orders
order_items
reviews
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio or VS Code
- A Supabase account

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/your-username/shopons.git
cd shopons
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Add your Supabase credentials**

Create `lib/core/config/supabase_config.dart`:
```dart
class SupabaseConfig {
  static const String url = 'YOUR_SUPABASE_PROJECT_URL';
  static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

> ⚠️ Never commit your real keys to GitHub.
> Add this file to `.gitignore`.

**4. Run the app**
```bash
# Android
flutter run

# Web
flutter run -d chrome
```

---

## 📦 Dependencies

```yaml
dependencies:
  supabase_flutter: latest
  get: latest
  flutter_animate: latest
  animated_text_kit: latest
  shimmer: latest
  confetti: latest
  lottie: latest
  cached_network_image: latest
```

---

## 💳 Payment

- ✅ Cash on Delivery supported
- 🔄 Online payment is a demo simulation only
- ❌ No real payment gateway integrated yet

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/          # Supabase config
│   ├── theme/           # App colors & theme
│   └── routes/          # GetX routes
├── features/
│   ├── auth/            # Login, Signup
│   ├── home/            # Home page
│   ├── products/        # Product listing & detail
│   ├── cart/            # Cart
│   ├── checkout/        # Checkout
│   ├── orders/          # Orders
│   ├── wishlist/        # Wishlist
│   ├── profile/         # Profile
│   ├── vendor/          # Vendor dashboard (WIP)
│   └── admin/           # Admin panel (WIP)
└── main.dart
```

---

## 🔐 Security Notes

- Row Level Security (RLS) enabled on Supabase tables
- Anon key used for client-side only
- Service role key never exposed in frontend
- `.gitignore` includes config files with credentials

---

## 🚧 What I Am Currently Working On

- [ ] Fixing vendor dashboard navigation bugs
- [ ] Fixing admin panel data loading issues
- [ ] Completing order tracking system
- [ ] Connecting all home page sections to Supabase
- [ ] Improving web responsiveness
- [ ] Adding full animation polish

---

## 🚀 Planned Future Features

- [ ] Real payment gateway (EasyPaisa / SadaPay)
- [ ] Push notifications
- [ ] AI outfit recommendations
- [ ] Voice search
- [ ] Loyalty points system
- [ ] Social login (Google)
- [ ] Urdu language support

---

## 🙋 About This Project

This is a **solo learning project** built to practice:
- Flutter app development
- Supabase backend integration
- GetX state management
- Multi-role app architecture
- Real-world e-commerce flows

I am a beginner developer actively learning and improving this project. Feedback, suggestions and contributions are welcome!

---

## 🤝 Contributing

Since this is a learning project, feel free to open issues or suggest improvements.

1. Fork the repo
2. Create a branch `git checkout -b fix/your-fix`
3. Commit `git commit -m 'Fix: description'`
4. Push `git push origin fix/your-fix`
5. Open a Pull Request

---

## 📄 License

MIT License — free to use and learn from.

---

## 👨‍💻 Developer

**Shahbaz**
- GitHub: [@msha82072-source](https://github.com/msha82072-source/Shopon-s)
- Learning Flutter | Building in public

---

<p align="center">Built with ❤️ while learning Flutter & Supabase</p>
