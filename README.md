# Venure App

**Your Ultimate Venue Booking Solution**

Venure is a mobile application designed to simplify the process of finding and booking event venues.  
Built for customers, it offers a seamless experience to search, view, and reserve venues based on location, capacity, event type, and budget — all in one place.

---

## 📱 Features

- **Advanced Venue Search**: Filter by location, event type, capacity, and budget.
- **Detailed Venue Profiles**: Photos, descriptions, amenities, pricing, and availability.
- **Real-Time Booking**: Instantly confirm venue reservations from within the app.
- **Favorites Management**: Save and quickly access your preferred venues.
- **Secure Payments**: Integrated with Stripe for safe, fast transactions.
- **User Profile**: Manage bookings, update profile, and view booking history.
- **Offline Access**: Cached venue data for a smooth experience even without internet.

---

## 🏗 Architecture & Design

Venure follows a **Clean Architecture** approach combined with the **MVVM (Model–View–ViewModel)** pattern.

- **MVVM** separates UI, business logic, and data handling for better maintainability.
- **Clean Architecture** ensures separation of concerns between layers:
  - **Domain Layer**: Core business rules & entities.
  - **Application Layer**: Use cases for booking, venue management, etc.
  - **Presentation Layer**: UI + ViewModels (state handling via Bloc).
  - **Infrastructure Layer**: API services, local storage (Hive), external integrations.

---

## 🗂 State Management

Venure uses the **Bloc (Business Logic Component)** pattern for predictable and scalable state management:

- **Events** trigger changes (e.g., search venues, book a venue).
- **Bloc** processes events and executes use cases.
- **States** represent the updated app condition for the UI.

---

## 🗄 Data Storage

- **Local Storage**: Hive for offline access to venues, bookings, and user profiles.
- **Remote Storage**: MongoDB via REST API for venue, booking, and transaction data.
- **Payment Handling**: Stripe API (PCI DSS compliant) — no sensitive payment data stored locally.

---

## 🔐 Security & Privacy

- JWT authentication for secure API access.
- HTTPS for encrypted data transmission (if enabled).
- Local encryption for sensitive data in Hive.
- Biometric authentication for payment actions.
- Compliance with privacy and ethical data handling principles.

---

## 📦 Tech Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Node.js, Express.js, MongoDB (MERN stack backend)
- **State Management**: Bloc
- **Local Database**: Hive
- **Payment Gateway**: Stripe
- **APIs**: RESTful services

---

## 🚀 Installation & Setup

1. **Clone the Repository**

   ```bash
   git clone https://github.com/AaryanBasnet/venureapp.git

    Navigate to Project Directory
   ```

cd venure

Install Dependencies

flutter pub get

Run the App

    flutter run

📌 Future Enhancements

    AI-powered venue recommendations.

    Multi-language support.

    In-app chat for customer-venue communication.

    Advanced booking analytics for users.

📄 License

This project is licensed under the MIT License.
👨‍💻 Author

[Aaryan Basnet]
[basnetaryan1011@gmail.com]
[https://github.com/AaryanBasnet]
